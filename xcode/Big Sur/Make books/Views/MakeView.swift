//  MakeView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Views

// The action buttons.

struct MakeView: View {
    /// Get the books with all options
    @EnvironmentObject var books: Books
    /// Get the Make options
    var makeOptions: MakeOptions
    /// Observe script related stuff
    @EnvironmentObject var scripts: Scripts
    /// Saved settings
    @AppStorage("pathBooks") var pathBooks: String = GetDocumentsDirectory()
    @AppStorage("pathExport") var pathExport: String = GetDocumentsDirectory()
    @AppStorage("pdfFont") var pdfFont: String = "11pt"
    @AppStorage("pdfPaper") var pdfPaper: String = "ebook"
    /// The View
    var body: some View {
        // BEGIN action buttons
        Text(books.bookSelected != nil ? "\"" + books.bookSelected!.title + "\" is selected" : " ")
            .font(.caption)
            .foregroundColor(Color.secondary)
            .animation(.easeInOut)
        HStack {
            // Make selected book.
            Button(
                action: {
                    let script = Bundle.main.url(forResource: "terminal/\(books.bookSelected!.script)", withExtension: nil)
                    let makeBook = makeProcess()
                    makeBook.arguments! += ["cd '" +
                            books.bookSelected!.path +
                            "' && '" + script!.path + "' " +
                            GetArgs(makeOptions, pathBooks, pathExport, pdfPaper, pdfFont)
                    ]
                    do {
                        try makeBook.run()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }){
                Text("Selected book")}
                /// Disable this button if no book is selected.
                .disabled(books.bookSelected == nil)

            Button(
                action: {
                    let script = Bundle.main.url(forResource: "terminal/make-all-books", withExtension: nil)
                    let makeAllBooks = makeProcess()
                    makeAllBooks.arguments! += ["'\(script!.path)' " +
                            GetArgs(makeOptions, pathBooks, pathExport, pdfPaper, pdfFont)]
                    do {
                        try makeAllBooks.run()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }){
                Text("All books")}

            Button(
                action: {
                    let script = Bundle.main.url(forResource: "terminal/make-all-collections", withExtension: nil)
                    let makeAllCollections = makeProcess()
                    makeAllCollections.arguments! += ["'\(script!.path)' " +
                            GetArgs(makeOptions, pathBooks, pathExport, pdfPaper, pdfFont)]
                    do {
                        try makeAllCollections.run()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }){
                Text("Collections")}
            
            Button(
                action: {
                    let script = Bundle.main.url(forResource: "terminal/make-all-tags", withExtension: nil)
                    let makeAllTags = makeProcess()
                    makeAllTags.arguments! += ["'\(script!.path)' " +
                            GetArgs(makeOptions, pathBooks, pathExport, pdfPaper, pdfFont)]
                    do {
                        try makeAllTags.run()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }){
                Text("Tags")}
        }
        .padding([.leading, .bottom, .trailing])
        .disabled(scripts.showSheet)
        // END actions buttons
    }
    // END body:
    
    func makeProcess() -> Process {
        /// Start with a fresh log
        scripts.log = [Log(type: .logStart, message: "Making your books")]
        scripts.activeSheet = .log
        scripts.isRunning = true
        scripts.showSheet = true
        ///Make a new process
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["--login","-c"]
        /// Logging stuff
        let standardOutput = Pipe()
        let standardError = Pipe()
        /// Gab the STOUT
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
        /// Gab the STERR
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
        process.terminationHandler =  {
            _ in DispatchQueue.main.async {
                scripts.isRunning = false
                scripts.log.append(Log(type: .logEnd, message: "Done!"))
            }
        }
        return process
    }
}
// END struct MakeView: View

