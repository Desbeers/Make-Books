//
//  BooksModel.swift
//  Make Books
//
//  Copyright © 2023 Nick Berendsen
//

import Foundation

// MARK: ObservableObject: Books

/// The class with the list of  books
final class Books: ObservableObject {
    /// The list of books
    @Published var bookList: [BookItem] = []
    /// The optional selected book in the sidebar
    @Published var selectedBook: BookItem?
    /// The list of authors
    @Published var authorList: [AuthorItem] = []
    /// The `Make Books` config files
    private let makeBooksConfigFiles = ["make-book.md", "make-collection.md", "make-tag-book.md"]
}

extension Books {

    /// Get the book files from the user selected folder
    @MainActor func getFiles() async {
        /// Clear optional selected book
        selectedBook = nil
        /// The found books
        var books = [BookItem]()
        /// Get a list of all files
        await FolderBookmark.action(bookmark: "BooksPath") { persistentURL in
            if let items = FileManager.default.enumerator(at: persistentURL, includingPropertiesForKeys: nil) {
                while let item = items.nextObject() as? URL {
                    if makeBooksConfigFiles.contains(item.lastPathComponent) {
                        var book = BookItem(folderURL: item.deletingLastPathComponent().deletingLastPathComponent())
                        parseBookFile(item, &book)
                        books.append(book)
                    }
                }
            }
        }
        /// Use the Dictionary(grouping:) function so that all the authors are grouped together.
        let grouped = Dictionary(grouping: books) { (occurrence: BookItem) -> String in
            occurrence.author
        }
        /// We now map over the dictionary and create our author objects.
        /// Then we want to sort them so that they are in the correct order.
        authorList = grouped.map { author -> AuthorItem in
            /// Sort the list by last name
            var sortName = " \(author.key)"
            if let index = sortName.lastIndex(of: " ") {
                sortName = String(sortName[index...])
            }
            return AuthorItem(
                name: author.key,
                sortName: sortName,
                books: author.value.sorted { $0.date < $1.date }
            )
        }
        .sorted { $0.sortName < $1.sortName }
        bookList = books.sorted { $0.title < $1.title }
    }
}

extension Books {

    /// Get the metadata of a book
    /// - Parameters:
    ///   - file: The config file
    ///   - book: The ``BookItem``
    private func parseBookFile( _ file: URL, _ book: inout BookItem) {
        /// Name is used when the regex doesn't work
        book.author = "Unknown author"
        book.title = file.lastPathComponent
        do {
            let data = try String(contentsOf: file, encoding: .utf8)
            for line in data.components(separatedBy: .newlines) {
                var value = ""
                if line.range(of: "[a-z]", options: .regularExpression) != nil {
                    let lineArr = line.components(separatedBy: ":")
                    /// Strip it clean...
                    if !lineArr[1].isEmpty {
                        value = lineArr[1].trimmingCharacters(in: .whitespaces)
                    }
                    switch lineArr[0] {
                    /// Metadata stuff...
                    case "author":
                        book.author = value
                    case "title":
                        book.title = value
                    case "date":
                        book.date = value
                    case "belongs-to-collection":
                        book.belongsToCollection = value
                    case "group-position":
                        book.groupPosition = Int(value) ?? 1
                    /// Internal stuff...
                    case "collection":
                        /// This book is a collection:
                        book.type = .collection
                        book.collection = value
                    case "add-to-collection":
                        let add = lineArr[1].components(separatedBy: ";")
                        add.forEach { item in
                            let part = item.components(separatedBy: "=")
                            let collection = BookCollection(
                                name: part[0].trimmingCharacters(in: .whitespaces),
                                position: part[1].trimmingCharacters(in: .whitespaces)
                            )
                            book.addToCollection.append(collection)
                        }
                    case "tag":
                        /// This book is a tag collection:
                        book.type = .tag
                        book.tag = value
                    default:
                        break
                    }
                }
            }
        } catch {
            print(error)
        }
        var cover = file
        cover.deleteLastPathComponent()
        cover.appendPathComponent("cover-screen.jpg")
        if doesFileExists(url: cover) {
            book.coverURL = cover
        }
    }
}

// MARK: struct & enum

/// The structure of a book item
struct BookItem: Identifiable, Hashable {
    var id = UUID()
    var folderURL: URL
    var title: String = ""
    var author: String = ""
    var date: String = ""
    var coverURL: URL?
    var belongsToCollection: String?
    var groupPosition: Int = 1
    var groupPositionRoman: String {
        return romanNumber(number: groupPosition)
    }
    var type: BookType = .book
    var tag: String = ""
    var collection: String = ""
    var addToCollection = [BookCollection]()
    var search: String {
        return "\(title) \(author)"
    }
    var help: String {
        return "\(author): \(title)"
    }
    var description: String {
        switch type {
        case .collection:
            return "Collection"
        case .tag:
            return "Tag: \(tag)"
        default:
            return "Book"
        }
    }
}

/// Type of book with the name of its script.
enum BookType: String {
    case book = "terminal/make-book"
    case collection = "terminal/make-collection"
    case tag = "terminal/make-tag-book"
    case allBooks = "terminal/make-all-books"
    case allCollections = "terminal/make-all-collections"
    case allTags = "terminal/make-all-tags"
    case makePDF = "terminal/make-pdf"
}

/// The structure of a book collection
struct BookCollection: Identifiable, Hashable {
    var id = UUID()
    var name: String = ""
    var position: String = ""
}

/// The structure of a author item
struct AuthorItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let sortName: String
    let books: [BookItem]
}
