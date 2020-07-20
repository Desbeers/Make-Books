//  BooksView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Views

// The list of books

struct BooksView: View {
    /// Get the books with all options
    @EnvironmentObject var books: Books
    /// The view
    var body: some View {
        VStack() {
            /// id: \.self is needed, else selection does not work
            List(books.bookList, id: \.self, selection: self.$books.bookSelected){book in
                HStack(alignment: .center) {
                    Image(nsImage: GetCover(cover: book.cover))
                        .resizable().frame(width: 60.0, height: 90.0)
                    VStack(alignment: .leading) {
                        Text(book.title).fontWeight(.bold)
                        HStack(spacing: 0) {
                            Text(book.collection)
                            Text(" ")
                            Text(book.position)
                        }
                        Text(book.author)
                        Text(book.type + " ∙ " + book.date.prefix(4)).font(.caption).foregroundColor(Color.secondary)
                    }
                    /// Push all above to the left
                    Spacer()
                }
                .padding(.vertical, 8.0)
            }.listStyle(SidebarListStyle())
                /// Hackish: get the list full width
                .padding(.leading, -8)
            Divider().padding(.horizontal)
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
                Text("Make selected book")
            }
            .disabled(books.bookSelected == nil)
            .disabled(books.showSheet)
            .padding(.bottom)
        }
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView().environmentObject(Books())
    }
}
