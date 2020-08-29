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
    @State var search: String = ""
    /// The view
    var body: some View {
        VStack() {
            SearchField(text: $search)
                .padding(.horizontal)
            /// id: \.self is needed, else selection does not work
            List(books.bookList
                    .filter({search.isEmpty ? true : $0.search.contains(search)})
                 ,
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

struct SearchField: NSViewRepresentable {
    @Binding var text: String
    /// Get the books with all options
    @EnvironmentObject var books: Books
    func makeNSView(context: Context) -> NSSearchField {
        let searchField = NSSearchField()
        searchField.delegate = context.coordinator
        return searchField
    }
    func updateNSView(_ nsView: NSSearchField, context: Context) {
        nsView.stringValue = text
    }
    func makeCoordinator() -> SearchField.Coordinator {
        Coordinator(parent: self)
    }
    class Coordinator: NSObject, NSSearchFieldDelegate  {
        let parent: SearchField
        init(parent: SearchField) {
            self.parent = parent
        }
        func controlTextDidChange(_ obj: Notification) {
            let searchField = obj.object as! NSSearchField
            parent.text = searchField.stringValue
            /// Clear the selected book (if any)
            parent.books.bookSelected = nil
        }
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
        .padding(.vertical, 6)
    }
}
