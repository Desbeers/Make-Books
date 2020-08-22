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
    /// The View
    var body: some View {
        // BEGIN action buttons
        HStack {
            Button(
             action: {
                 self.books.scripsRunning = true
                 self.books.activeSheet = "log"
                 self.books.showSheet = true
                 let makeBook = Process()
                 makeBook.executableURL = URL(fileURLWithPath: "/bin/zsh")
                 makeBook.arguments = [
                     "--login","-c", "cd '" +
                     self.books.bookSelected!.path +
                     "' && " + self.books.bookSelected!.script + " " +
                     GetArgs(self.books)
                 ]
                 makeBook.terminationHandler =  {
                     _ in DispatchQueue.main.async {self.books.scripsRunning = false }
                 }
                 try! makeBook.run()
             }){
             Text("Selected book")
            }
            .disabled(books.bookSelected == nil)
            Button(
                action: {
                    self.books.scripsRunning = true
                    self.books.activeSheet = "log"
                    self.books.showSheet = true
                    let makeAllBooks = Process()
                    makeAllBooks.executableURL = URL(fileURLWithPath: "/bin/zsh")
                    makeAllBooks.arguments = ["--login","-c", "make-all-books " + GetArgs(self.books)]
                    makeAllBooks.terminationHandler =  { _ in DispatchQueue.main.async {self.books.scripsRunning = false }}
                    try! makeAllBooks.run()
                }){
                Text("All books")}
            Button(
                action: {
                    self.books.scripsRunning = true
                    self.books.activeSheet = "log"
                    self.books.showSheet = true
                    let makeCollection = Process()
                    makeCollection.executableURL = URL(fileURLWithPath: "/bin/zsh")
                    makeCollection.arguments = ["--login","-c", "make-all-collections " + GetArgs(self.books)]
                    makeCollection.terminationHandler =  { _ in DispatchQueue.main.async {self.books.scripsRunning = false }}
                    try! makeCollection.run()
                }){
                Text("Collections")}
            Button(
                action: {
                    self.books.scripsRunning = true
                    self.books.activeSheet = "log"
                    self.books.showSheet = true
                    let makeFavorites = Process()
                    makeFavorites.executableURL = URL(fileURLWithPath: "/bin/zsh")
                    makeFavorites.arguments = ["--login","-c", "make-all-tags " + GetArgs(self.books)]
                    makeFavorites.terminationHandler =  { _ in DispatchQueue.main.async {self.books.scripsRunning = false }}
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
