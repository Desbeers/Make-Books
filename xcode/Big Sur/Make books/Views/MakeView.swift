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
    /// Saved settings
    @AppStorage("pathBooksString") var pathBooks: String = GetDocumentsDirectory()
    @AppStorage("pathExportString") var pathExport: String = GetDocumentsDirectory()
    @AppStorage("pdfFont") var pdfFont: String = "11pt"
    @AppStorage("pdfPaper") var pdfPaper: String = "ebook"
    /// The View
    var body: some View {
        // BEGIN action buttons
        HStack {
            // Make selected book.
            Button(
                action: {
                    books.scripsRunning = true
                    books.showSheet = true
                    let makeBook = Process()
                    makeBook.executableURL = URL(fileURLWithPath: "/bin/zsh")
                    makeBook.arguments = [
                        "--login","-c", "cd '" +
                            books.bookSelected!.path +
                            "' && " + books.bookSelected!.script + " " +
                            GetArgs(books, pathBooks, pathExport, pdfPaper, pdfFont)
                    ]
                    makeBook.terminationHandler =  {
                        _ in DispatchQueue.main.async { books.scripsRunning = false }
                    }
                    try! makeBook.run()
                }){
                Text("Selected book")}
                /// Disable this button if no book is selected.
                .disabled(books.bookSelected == nil)
            Button(
                action: {
                    books.scripsRunning = true
                    books.showSheet = true
                    let makeAllBooks = Process()
                    makeAllBooks.executableURL = URL(fileURLWithPath: "/bin/zsh")
                    makeAllBooks.arguments = [
                        "--login","-c", "make-all-books " +
                            GetArgs(books, pathBooks, pathExport, pdfPaper, pdfFont)]
                    makeAllBooks.terminationHandler =  {
                        _ in DispatchQueue.main.async { books.scripsRunning = false }
                    }
                    try! makeAllBooks.run()
                }){
                Text("All books")}
            Button(
                action: {
                    books.scripsRunning = true
                    books.showSheet = true
                    let makeCollection = Process()
                    makeCollection.executableURL = URL(fileURLWithPath: "/bin/zsh")
                    makeCollection.arguments = [
                        "--login","-c", "make-all-collections " +
                            GetArgs(books, pathBooks, pathExport, pdfPaper, pdfFont)
                    ]
                    makeCollection.terminationHandler =  {
                        _ in DispatchQueue.main.async { books.scripsRunning = false }
                    }
                    try! makeCollection.run()
                }){
                Text("Collections")}
            Button(
                action: {
                    books.scripsRunning = true
                    books.showSheet = true
                    let makeFavorites = Process()
                    makeFavorites.executableURL = URL(fileURLWithPath: "/bin/zsh")
                    makeFavorites.arguments = [
                        "--login","-c", "make-all-tags " +
                            GetArgs(books, pathBooks, pathExport, pdfPaper, pdfFont)]
                    makeFavorites.terminationHandler =  {
                        _ in DispatchQueue.main.async { books.scripsRunning = false }
                    }
                    try! makeFavorites.run()
                }){
                Text("Tags")}
        }.padding([.leading, .bottom, .trailing]).disabled(books.showSheet)
        // END actions buttons
    }
    // END body:
}
// END struct ContentView: View

// Preview
struct MakeView_Previews: PreviewProvider {
    static var previews: some View {
        MakeView().environmentObject(Books())
    }
}
