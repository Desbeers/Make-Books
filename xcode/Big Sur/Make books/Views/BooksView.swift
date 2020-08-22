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

    @AppStorage("pathBooks") var pathBooks: String = FileManager.default.homeDirectoryForCurrentUser.path
    @AppStorage("pathExport") var pathExport: String = FileManager.default.homeDirectoryForCurrentUser.path

    //var bookList = GetBooks()

    /// The view
    var body: some View {
        NavigationView  {
            /// id: \.self is needed, else selection does not work
            List(books.bookList, id: \.self, selection: self.$books.bookSelected) { book in
                /// The list item is in a subview.
                BooksItem(book: book)
            }
            //.frame(minWidth: 200, idealWidth: 200, maxWidth: 350, maxHeight: .infinity)
        }
        //.frame(minWidth: 200)
        .listStyle(SidebarListStyle())
        .navigationSubtitle("Write a beautifull book")
        .toolbar {
            ToolbarItem {
                
                Button(action: {
                    SelectBooksFolder(books)
                } ) {
                    HStack {
                    Image(systemName: "square.and.arrow.up.on.square")
                    Text(GetLastPath(pathBooks))
                    }
                }
                .help("The folder with your books")
            }

            ToolbarItem {
                
                Button(action: {
                    SelectExportFolder()
                } ) {
                    Image(systemName: "square.and.arrow.down.on.square")
                    Text(GetLastPath(pathExport))
                }
                .help("The export folder")
            }
        }
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView().environmentObject(Books())
    }
}

struct BooksItem: View {
    var book = MetaBooks()
    var body: some View {
        HStack(alignment: .center) {
            Image(nsImage: GetCover(cover: book.cover))
                .resizable().frame(width: 60.0, height: 90.0)
            VStack(alignment: .leading) {
                Text(book.title).fontWeight(.bold).lineLimit(2)
                Text(book.author)
                if !book.collection.isEmpty {
                    Text(book.collection + " " + book.position).font (.caption)
                }
                Text(book.type + " ∙ " + book.date.prefix(4)).font(.caption).foregroundColor(Color.secondary)
            }
            /// Push all above to the left
            Spacer()
        }
        .padding(.vertical, 8.0)
    }
}
