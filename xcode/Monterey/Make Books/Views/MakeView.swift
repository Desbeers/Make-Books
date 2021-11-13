//  MakeView.swift
//  Make books
//
//  Copyright © 2021 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - View: MakeView

// The action buttons.

struct MakeView: View {
    /// Get the list of books
    @EnvironmentObject var books: Books
    /// Get the Make options
    var makeOptions: MakeOptions
    /// Observe script related stuff
    @EnvironmentObject var scripts: Scripts
    /// Saved settings
    @AppStorage("pathBooks") var pathBooks: String = getDocumentsDirectory()
    @AppStorage("pathExport") var pathExport: String = getDocumentsDirectory()
    @AppStorage("pdfFont") var pdfFont: String = "11pt"
    @AppStorage("pdfPaper") var pdfPaper: String = "ebook"
    // START body
    var body: some View {
        // BEGIN action buttons
        Text(books.bookSelected != nil ? "\"\(books.bookSelected!.title)\" is selected" : " ")
            .font(.caption)
            .foregroundColor(Color.secondary)
            .animation(.easeInOut)
        HStack {
            /// Make selected book
            Button {
                let script = Bundle.main.url(forResource: books.bookSelected!.type.rawValue, withExtension: nil)
                let makeBook = makeProcess()
                makeBook.arguments! += ["cd '" +
                                            books.bookSelected!.path +
                                            "' && '" + script!.path + "' " +
                                            getArgs(makeOptions, pathBooks, pathExport, pdfPaper, pdfFont)
                ]
                do {
                    try makeBook.run()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            } label: {
                Text("Selected book")
            }
            .disabled(books.bookSelected == nil)
            /// Make all books
            Button {
                let script = Bundle.main.url(forResource: BookItem.BookType.allBooks.rawValue, withExtension: nil)
                let makeAllBooks = makeProcess()
                makeAllBooks.arguments! += ["'\(script!.path)' " +
                        getArgs(makeOptions, pathBooks, pathExport, pdfPaper, pdfFont)]
                do {
                    try makeAllBooks.run()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            } label: {
                Text("All books")
            }
            /// Make all collections
            Button {
                let script = Bundle.main.url(forResource: BookItem.BookType.allCollections.rawValue, withExtension: nil)
                let makeAllCollections = makeProcess()
                makeAllCollections.arguments! += ["'\(script!.path)' " +
                        getArgs(makeOptions, pathBooks, pathExport, pdfPaper, pdfFont)]
                do {
                    try makeAllCollections.run()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            } label: {
                Text("Collections")
            }
            /// Make all tags
            Button {
                let script = Bundle.main.url(forResource: BookItem.BookType.allTags.rawValue, withExtension: nil)
                let makeAllTags = makeProcess()
                makeAllTags.arguments! += ["'\(script!.path)' " +
                        getArgs(makeOptions, pathBooks, pathExport, pdfPaper, pdfFont)]
                do {
                    try makeAllTags.run()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            } label: {
                Text("Tags")
            }
        }
        .padding([.leading, .bottom, .trailing])
        .disabled(scripts.showSheet)
        // END actions buttons
    }
    // START makeProcess
    func makeProcess() -> Process {
        /// Start with a fresh log
        scripts.log = [Log(type: .logStart, message: "Making your books")]
        scripts.activeSheet = .log
        scripts.isRunning = true
        scripts.showSheet = true
        /// Make a new process
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["--login", "-c"]
        /// Logging stuff
        let standardOutput = Pipe()
        let standardError = Pipe()
        /// Grab the STOUT
        standardOutput.fileHandleForReading.readabilityHandler = { pipe in
            if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
                if !line.isEmpty {
                    var type: Log.LogType = .unknown
                    var message = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    let lineArr = message.components(separatedBy: ":")
                    switch lineArr[0] {
                    case "action":
                        type = .action
                        message = lineArr[1]
                    case "notice":
                        type = .notice
                        message = lineArr[1]
                    case "targetStart":
                        type = .targetStart
                        message = lineArr[1]
                    case "targetEnd":
                        type = .targetEnd
                        message = lineArr[1]
                    case "targetClean":
                        type = .targetClean
                        message = lineArr[1]
                    default:
                        type = .unknown
                    }
                    DispatchQueue.main.sync {
                        scripts.log.append(Log(type: type, message: message))
                    }
                }
            }
        }
        /// Grab the STERR
        standardError.fileHandleForReading.readabilityHandler = { pipe in
            if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
                if !line.isEmpty {
                    DispatchQueue.main.sync {
                        scripts.log.append(Log(type: .error, message: line.trimmingCharacters(in: .whitespacesAndNewlines)))
                    }
                }
            }
        }
        process.standardOutput = standardOutput
        process.standardError = standardError
        /// Notice for end of process
        process.terminationHandler = { _ in DispatchQueue.main.async {
                scripts.isRunning = false
                scripts.log.append(Log(type: .logEnd, message: "Done!"))
            }
        }
        return process
    }
}
