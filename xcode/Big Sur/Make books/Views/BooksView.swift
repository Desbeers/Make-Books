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
    /// Saved settings
    @AppStorage("pathBooks") var pathBooks: String = GetDocumentsDirectory()
    @AppStorage("pathExport") var pathExport: String = GetDocumentsDirectory()
    @State var searchText: String = ""
    /// The view
    var body: some View {
        VStack() {
            SearchBar(text: $searchText)
            /// id: \.self is needed, else selection does not work
            List(books.bookList
                    .filter({searchText.isEmpty ? true : $0.title.contains(searchText) || $0.author.contains(searchText) }),
                        id: \.self, selection: $books.bookSelected) { book in
                /// The list item is in a subview.
                BooksItem(book: book)
            }
        }
        .frame(minWidth: 240)
        .listStyle(SidebarListStyle())
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView().environmentObject(Books())
    }
}

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    /// Get the books with all options
    @EnvironmentObject var books: Books
    var body: some View {
        TextField("Search", text: $text)
        .padding(.horizontal)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        /// Clear the selected book (if any)
        .onTapGesture {
            books.bookSelected = nil
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
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
        .padding(.vertical)
    }
}
