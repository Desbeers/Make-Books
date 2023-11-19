//
//  Library.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import Foundation
import SwiftlyFolderUtilities

/// The class with the Library
@Observable
final class Library {
    /// The list of books
    var books: [Book] = []
    /// The list of collections
    var collections: [Book] {
        books.filter { $0.media == .collection }
    }
    /// The list of authors
    var authors: [Author] {
        /// Use the Dictionary(grouping:) function so that all the authors are grouped together.
        let grouped = Dictionary(grouping: books) { book -> String in
            book.author
        }
        /// We now map over the dictionary and create our author objects.
        /// Then we want to sort them so that they are in the correct order.
        let authors = grouped.map { author -> Author in
            /// Sort the list by last name
            var sortName = " \(author.key)"
            if let index = sortName.lastIndex(of: " ") {
                sortName = String(sortName[index...]).trimmingCharacters(in: .whitespaces)
            }
            return Author(
                name: author.key,
                sortName: sortName,
                books: author.value
            )
        }
            .sorted(using: [
                KeyPathComparator(\.sortName),
                KeyPathComparator(\.name)
            ])
        return authors
    }
    /// The list of series
    var series: [Serie] {
        let books = books.filter { $0.belongsToSerie != nil }

        /// Use the Dictionary(grouping:) function so that all the series are grouped together.
        let grouped = Dictionary(grouping: books) { book -> String in
            book.belongsToSerie ?? ""
        }
        /// We now map over the dictionary and create our serie objects.
        /// Then we want to sort them so that they are in the correct order.
        let series = grouped.map { serie -> Serie in
            let authors = Set(serie.value.map(\.author))
            return Serie(
                title: serie.key,
                authors: Array(authors),
                books: serie.value.sorted(using: KeyPathComparator(\.seriePosition))
            )
        }
        return series.sorted(using: KeyPathComparator(\.title))
    }
    /// The list of tag-books
    var tags: [Book] {
        books.filter { $0.media == .tag }
    }
    /// The settings to sort a list of books
    var listSortSettings: [Sort] = BookListSort.getAllSortSettings()
}

extension Library {

    /// Get a link to a ``Collection``
    /// - Parameter collection: The ``Collection``
    /// - Returns: A ``Router`` item
    func getCollectionLink(collection: Book ) -> Router {
        if let books = getCollectionBooks(collection: collection) {
            return .collection(collection: Collection(book: collection, books: books))
        }
        return .collections
    }

    /// Get all books from a ``Collection``
    /// - Parameter collection: The ``Collection``
    /// - Returns: A ``Book`` array
    func getCollectionBooks(collection: Book ) -> [Book]? {
        if let name = collection.collection {
            let books = books
                .filter { book -> Bool in
                    book.collectionItems.contains { $0.name == name }
                }
                .sorted {
                    $0.collectionItems.first { $0.name == collection.collection }?.collectionPosition ?? 0
                    < $1.collectionItems.first { $0.name == collection.collection }?.collectionPosition ?? 0
                }
            return books
        }
        return nil
    }
}

extension Library {
    /// Get the `List Sort` settings for a View
    /// - Parameter sortID: The ID of the sorting
    func getSortSetting(router: Router) -> Sort {
        if let sorting = listSortSettings.first(where: { $0.id == router.item.id }) {
            return sorting
        }
        return Sort(id: router.item.id, method: router.item.defaultSort.method, order: router.item.defaultSort.order)
    }
}

extension Library {

    /// Get all the books
    @MainActor
    func getAllBooks() async {
        do {
            /// The found books
            var books = [Book]()
            /// Get a list of all files
            try await FolderBookmark.action(bookmark: UserSetting.booksFolder.rawValue) { persistentURL in
                if let items = FileManager.default.enumerator(at: persistentURL, includingPropertiesForKeys: nil) {
                    while let item = items.nextObject() as? URL {
                        if StaticSetting.makeBooksConfigFiles.contains(item.lastPathComponent) {
                            var book = Book(
                                yalmURL: item
                            )
                            parseBookFile(item, &book)
                            books.append(book)
                        }
                    }
                }
            }
            self.books = books.sorted(sortItem: Sort(method: .title))
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension Library {

    /// Get the metadata of a book
    /// - Parameters:
    ///   - file: The config file
    ///   - book: The ``BookItem``
    private func parseBookFile( _ file: URL, _ book: inout Book) {
        /// Name is used when the regex doesn't work
        book.author = "Unknown author"
        book.title = file.lastPathComponent
        book.sourceURL = file.deletingLastPathComponent().deletingLastPathComponent()
        book.status = .existing
        do {
            let data = try String(contentsOf: file, encoding: .utf8)

            for line in data.components(separatedBy: .newlines) {
                if let match = line.wholeMatch(of: Library.metaDataRegex) {
                    /// Get the result of the match
                    let key = match.1
                    let value = match.2
                    /// Assign the metadata
                    switch key {
                    case .title:
                        book.title = value
                    case .author:
                        book.author = value
                    case .description:
                        book.description = value
                    case .date:
                        book.date = value
                    case .rights:
                        book.rights = value
                    case .publisher:
                        book.publisher = value
                    case .language:
                        book.language = value
                    case .subject:
                        book.subject = value
                    case .belongsToSerie:
                        book.belongsToSerie = value
                    case .seriePosition:
                        book.seriePosition = Int(value) ?? 1
                    case .addToCollection:
                        var items: [Collection.Item] = []
                        let add = value.components(separatedBy: ";")
                        add.forEach { item in
                            let part = item.components(separatedBy: "=")
                            let item = Collection.Item(
                                name: part[0].trimmingCharacters(in: .whitespaces),
                                collectionPosition: Int(part[1].trimmingCharacters(in: .whitespaces)) ?? 1
                            )
                            items.append(item)
                        }
                        book.collectionItems = items
                    case .collection:
                        /// This book is a collection:
                        book.media = .collection
                        book.collection = value
                    case .tag:
                        /// This book is a tag collection:
                        book.media = .tag
                        book.tag = value
                    case .hasBeenRead:
                        book.hasBeenRead = value == "1" ? true : false
                    case .chapterStyle:
                        book.chapterStyle = Book.ChapterStyle(rawValue: value)
                    case .media:
                        book.media = Media(rawValue: value) ?? .book
                    default:
                        break
                    }
                }
            }
        } catch {
            print(error)
        }
        /// Check if there is a cover
        var cover = file
        cover.deleteLastPathComponent()
        cover.appendPathComponent("cover-screen.jpg")
        if cover.exist() {
            book.coverURL = cover
        }
    }
}
