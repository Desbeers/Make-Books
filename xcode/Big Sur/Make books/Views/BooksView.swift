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
        }
        .toolbar {
            ToolbarItem {
                
                Button(action: {
                    SelectBooksFolder(books)
                } ) {
                    HStack {
                    Image(systemName: "square.and.pencil")
                    Text(GetLastPath(pathBooks))
                    }
                }
            }

            ToolbarItem {
                
                Button(action: {
                    SelectExportFolder()
                } ) {
                    Image(systemName: "books.vertical")
                    Text(GetLastPath(pathExport))
                    
                }
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
                Text(book.title).fontWeight(.bold)
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

struct ToolbarModifier: ViewModifier {
    func body(content: Content) -> some View {

        content
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        
                    } ) {

                    }
                }

                ToolbarItem {
                    Button(action: {
                        
                    } ) {
                        Image(systemName: "uiwindow.split.2x1")
                    }
                }
            }
    }
}
