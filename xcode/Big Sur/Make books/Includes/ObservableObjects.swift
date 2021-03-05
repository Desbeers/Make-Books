//  ObservableOjects.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Observable classes

class Books: ObservableObject {
    @Published var bookList = GetBooksList()
    @Published var bookSelected: AuthorBooks?
}

class MakeOptions: ObservableObject {
    @Published var options: [Make]
    init() {
        self.options = GetMakeOptions()
    }
}

class Scripts: ObservableObject {
    /// State of zsh scripts
    @Published var isRunning = false
    /// Log from zsh scripts
    @Published var log = [Log]()
    /// Show sheet with log or dropper
    @Published var showSheet = false
    @Published var activeSheet: ActiveSheet = .log
    /// The type of sheet we can show
    enum ActiveSheet {
        case log, dropper
    }
}

// MARK: - Structs

struct Log: Identifiable, Equatable {
    let id = UUID()
    let type: LogType
    let message: String
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
    var type: String = ""
    var script: String = ""
    var search: String = ""
}

struct GetBooksList {
    let authors: [AuthorList]
    /// Fill the list.
    init() {
        /// Get the songs in the selected directory
        let books = GetBooksList.GetFiles()
        /// Use the Dictionary(grouping:) function so that all the artists are grouped together.
        let grouped = Dictionary(grouping: books) { (occurrence: AuthorBooks) -> String in
            occurrence.author
        }
        /// We now map over the dictionary and create our artist objects.
        /// Then we want to sort them so that they are in the correct order.
        self.authors = grouped.map { author -> AuthorList in
            AuthorList(name: author.key, books: author.value)
        }.sorted { $0.name < $1.name }
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
        /// There are books and collections in the list
        /// Assign the correct script.
        if name.hasSuffix("/make-book.md") {
            book.type = "Book"
            book.script = "make-book"
        }
        if name.hasSuffix("/make-collection.md") {
            book.type = "Collection"
            book.script = "make-collection"
        }
        if name.hasSuffix("/make-tag-book.md") {
            book.type = "tag"
            book.script = "make-tag-book"
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
                        book.search += lineArr[1]
                    case "title":
                        book.title = lineArr[1]
                        book.search += lineArr[1]
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

// MARK: - Options for Make

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
