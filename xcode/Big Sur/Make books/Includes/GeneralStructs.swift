//  GeneralStructs.swift
//  Make books
//
//  Copyright © 2021 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Struct: Log

// The logger for the scripts.

struct Log: Identifiable, Equatable {
    let id = UUID()
    let type: LogType
    let message: String
    /// The symbol used in the list of LogView
    var symbol: String {
        switch type {
        case .action:
            return "book"
        case .notice:
            return "info.circle.fill"
        case .error:
            return "xmark.octagon.fill"
        case .targetStart:
            return "gear"
        case .targetEnd:
            return "checkmark"
        case .targetClean:
            return "scissors"
        case .logStart:
            return "hourglass.tophalf.fill"
        case .logEnd:
            return "hourglass.bottomhalf.fill"
        default:
            return "questionmark"
        }
    }
    /// The color of the symbols used in the list of LogView
    var color: Color {
        switch type {
        case .error:
            return .red
        case .targetStart:
            return .orange
        case .targetEnd:
            return .green
        case .targetClean:
            return .blue
        default:
            return .primary
        }
    }
    /// Log types
    enum LogType: String {
        case action
        case notice
        case error
        case targetStart
        case targetEnd
        case targetClean
        case logStart
        case logEnd
        case unknown
    }
}

struct AuthorList: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let sortname: String
    let books: [AuthorBooks]
}

struct AuthorBooks: Identifiable, Hashable {
    var id = UUID()
    var title: String = ""
    var author: String = ""
    var date: String = ""
    var cover: URL? = nil
    var collection: String = ""
    var position: String = ""
    var path: String = ""
    var type: BookType = .book
    var search: String {
        return "\(title) \(author)"
    }
    /// The types of books and the name of its script.
    enum BookType: String {
        case book = "terminal/make-book"
        case collection = "terminal/make-collection"
        case tag = "terminal/make-tag-book"
        case allBooks = "terminal/make-all-books"
        case allCollections = "terminal/make-all-collections"
        case allTags = "terminal/make-all-tags"
        case makePDF = "terminal/make-pdf"
    }
}

struct GetBooksList {
    let authors: [AuthorList]
    /// Fill the list.
    init() {
        /// Get the books in the selected directory
        let books = GetBooksList.GetFiles()
        /// Use the Dictionary(grouping:) function so that all the authors are grouped together.
        let grouped = Dictionary(grouping: books) { (occurrence: AuthorBooks) -> String in
            occurrence.author
        }
        /// We now map over the dictionary and create our author objects.
        /// Then we want to sort them so that they are in the correct order.
        self.authors = grouped.map { author -> AuthorList in
            /// Sort the list by last name
            var sortname = " \(author.key)"
            if let i = sortname.lastIndex(of: " ") {
                sortname = String(sortname[i...])
            }
            return AuthorList(name: author.key, sortname: sortname, books: author.value)
        }.sorted { $0.sortname < $1.sortname }
    }
    /// This is a helper function to get the files.
    static func GetFiles() -> [AuthorBooks] {
        var books = [AuthorBooks]()
        let base = UserDefaults.standard.object(forKey: "pathBooks") as? String ?? GetDocumentsDirectory()
        /// Convert path to an url
        let directoryURL = URL(fileURLWithPath: base)
        /// Get a list of all files
        if let enumerator = FileManager.default.enumerator(atPath: directoryURL.path) {
            for case let item as String in enumerator {
                if item.hasSuffix("/make-book.md") || item.hasSuffix("/make-collection.md") || item.hasSuffix("/make-tag-book.md") {
                    var book = AuthorBooks()
                    ParseBookFile(directoryURL.appendingPathComponent(item, isDirectory: false), item, &book)
                    books.append(book)
                }
            }
        }
        /// Sort by by date and then title.
        return books.sorted { $0.date == $1.date ? $0.title < $1.title : $0.date < $1.date  }
    }
    /// This is a helper function to get the files.
    static func ParseBookFile(_ file: URL, _ name: String, _ book: inout AuthorBooks) {
        /// Name is used when the regex doesn't work
        book.author = "Unknown author"
        book.title = name
        book.path = file.path
        /// There are books-, collections- and tag-types of book.
        /// Assign the correct type.
        if name.hasSuffix("/make-book.md") {
            book.type = .book
        }
        if name.hasSuffix("/make-collection.md") {
            book.type = .collection
        }
        if name.hasSuffix("/make-tag-book.md") {
            book.type = .tag
        }
        
        do {
            let data = try String(contentsOf: file, encoding: .utf8)
            
            for line in data.components(separatedBy: .newlines) {
                let result = line.range(of: "[a-z]", options:.regularExpression)
                if (result != nil) {
                    let lineArr = line.components(separatedBy: ": ")
                    switch lineArr[0] {
                    case "author":
                        book.author = lineArr[1]
                    case "title":
                        book.title = lineArr[1]
                    case "date":
                        book.date = lineArr[1]
                    case "belongs-to-collection":
                        book.collection = lineArr[1]
                    case "group-position":
                        book.position = lineArr[1]
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
        if DoesFileExists(url: cover) {
            book.cover = cover
        }
        var path = file
        path.deleteLastPathComponent()
        path.deleteLastPathComponent()
        book.path = path.path
    }
}

// MARK: - Struct: MakeOption

// The options for Make

struct Make: Identifiable {
    var id = UUID()
    var make: String
    var label: String
    var text: String
    var isSelected: Bool
}

func GetMakeOptions() -> [Make] {
    var options = [Make]()
    /// The options
    options.append(Make(make: "clean", label: "Clean all files before processing",
                        text: "Be carefull, all exports will be removed!", isSelected: false))
    options.append(Make(make: "pdf", label: "Make a PDF",
                        text: "A PDF ment for screen, with cover and a coloured background. Good for reading on screen.", isSelected: true))
    options.append(Make(make: "print", label: "Make a printable file",
                        text: "This is also a PDF, however, no cover and has a white background. Good for printing.", isSelected: false))
    options.append(Make(make: "epub", label: "Make an ePub book",
                        text: "A modern ePub; ready for any reader that supports ePubs; like any reader should do.", isSelected: false))
    options.append(Make(make: "kobo", label: "Make a Kobo book",
                        text: "Make an ePub that is optimised for the Kobo e-reader.", isSelected: false))
    return options
}
