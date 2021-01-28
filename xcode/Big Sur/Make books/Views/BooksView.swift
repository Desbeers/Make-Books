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
    @State var search: String = ""
    
    var body: some View {
        VStack() {
            SearchField(text: $search).padding(.horizontal, 10)
            ScrollView() {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 110))],
                    alignment: .center,
                    spacing: 4,
                    pinnedViews: [.sectionHeaders, .sectionFooters]
                ) {
                    ForEach(books.bookList.authors) { author in
                        Section(header: search.isEmpty ? AuthorHeader(author: author) : nil) {
                            ForEach(author.books.filter({search.isEmpty ? true : $0.search.localizedCaseInsensitiveContains(search)}), id: \.self) { book in
                                BookListRow(book: book)
                                .onTapGesture{
                                    if (books.bookSelected == book) {
                                        books.bookSelected = nil
                                    } else {
                                        books.bookSelected = book
                                    }
                                }
                            }
                            .animation(.linear(duration: 0.5))
                        }
                    }
                }
            }
        }
    }
}

struct AuthorHeader: View {
    let author: AuthorList

    var body: some View {
        ZStack {
            //Color(NSColor.windowBackgroundColor).opacity(0.9)
            FancyBackground().opacity(0.9)
            VStack {
                HStack {
                    Spacer()
                    Text(author.name)
                    Spacer()
                }
                Divider().padding(.horizontal)
            }.padding(4)
        }
    }
}

struct BookListRow: View {
    let book: AuthorBooks
    /// Get the books with all options
    @EnvironmentObject var books: Books
    @State private var hovered = false

    var body: some View {
        VStack {
            if ((book.cover) != nil) {
                Image(nsImage: GetCover(cover: book.cover!.path))
                    .resizable().frame(width: 90.0, height: 135.0)
                    .shadow(color: .init(red: 0, green: 0, blue: 0, opacity: 0.4), radius: 2, x: 2, y: 2)
                    .cornerRadius(3)
            } else {
                ZStack {
                    Image(nsImage: NSImage(named: "CoverArt")!)
                        .resizable().frame(width: 90.0, height: 135.0)
                        .shadow(color: .init(red: 0, green: 0, blue: 0, opacity: 0.4), radius: 2, x: 2, y: 2)
                        .cornerRadius(3)
                    Text(book.title).padding(30)
                }
            }
        }
        .padding(10)
        .onHover { isHovered in
            self.hovered = isHovered
        }
        .help(
            GetHoverHelp(book)
        )
        .scaleEffect(hovered && books.bookSelected != book ? 1.1 : 1.0)
        .animation(.default, value: hovered)
        .background(books.bookSelected == book ? Color.accentColor : Color.clear).cornerRadius(4)
    }
}

struct SearchField: NSViewRepresentable {
    @Binding var text: String
    /// Get the books with all options
    @EnvironmentObject var books: Books
    func makeNSView(context: Context) -> NSSearchField {
        let searchField = NSSearchField()
        searchField.delegate = context.coordinator
        searchField.placeholderString = "Search for author or book"
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

extension NSSearchField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
