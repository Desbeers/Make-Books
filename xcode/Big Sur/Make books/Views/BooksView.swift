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
            /// id: \.self is needed, else selection does not work
            List(books.bookList, id: \.self, selection: self.$books.bookSelected) { book in
                /// The list item is in a subview.
                BooksItem(book: book)
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
                if !book.collection.isEmpty {
                    Text(book.collection + " " + book.position)
                }
                Text(book.author)
                Text(book.type + " ∙ " + book.date.prefix(4)).font(.caption).foregroundColor(Color.secondary)
            }
            /// Push all above to the left
            Spacer()
        }
        .padding(.vertical, 8.0)
    }
}
