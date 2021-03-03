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
                    let makeBook = makeProcess()
                    makeBook.arguments! += ["cd '" +
                            books.bookSelected!.path +
                            "' && " + books.bookSelected!.script + " " +
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
                    let makeAllBooks = makeProcess()
                    makeAllBooks.arguments! += ["make-all-books " +
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
                    let makeAllBooks = makeProcess()
                    makeAllBooks.arguments! += ["make-all-collections " +
                            GetArgs(makeOptions, pathBooks, pathExport, pdfPaper, pdfFont)]
                    do {
                        try makeAllBooks.run()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }){
                Text("Collections")}
            
            Button(
                action: {
                    let makeAllBooks = makeProcess()
                    makeAllBooks.arguments! += [
                        "--login","-c", "make-all-tags " +
                            GetArgs(makeOptions, pathBooks, pathExport, pdfPaper, pdfFont)]
                    do {
                        try makeAllBooks.run()
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
        scripts.log = "Making your books...\n\n"
        scripts.activeSheet = .log
        scripts.isRunning = true
        scripts.showSheet = true
        ///Make a new process
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = [ "--login","-c"]
        /// Logging stuff
        let pipe = Pipe()
        pipe.fileHandleForReading.readabilityHandler = { pipe in
            if let line = String(data: pipe.availableData, encoding: String.Encoding.utf8) {
                if !line.isEmpty {
                    DispatchQueue.main.sync {
                        scripts.log += line
                    }
                }
            }
        }
        process.standardOutput = pipe
        process.standardError = pipe
        /// Notice for end of process
        process.terminationHandler =  {
            _ in DispatchQueue.main.async { scripts.isRunning = false }
        }
        return process
    }
}
// END struct MakeView: View

