//  BooksView.swift
//  Make books
//
//  Copyright © 2021 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - View: BooksView

// The list of all books

struct BooksView: View {
    /// Get the list of books
    @EnvironmentObject var books: Books
    @State var search: String = ""
    /// Saved settings
    @AppStorage("pathExport") var pathExport: String = GetDocumentsDirectory()
    // START body
    var body: some View {
        VStack() {
            SearchField(text: $search)
                .padding(.horizontal, 10)
            List(selection: $books.bookSelected) {
                ForEach(books.bookList.authors) { author in
                    Section(header: BookListHeader(author: author)) {
                        ForEach(author.books.filter({search.isEmpty ? true : $0.search.localizedCaseInsensitiveContains(search)}), id: \.self) { book in
                            BookListRow(book: book)
                            .contextMenu {
                                Button(action: {
                                    OpenInFinder(url: URL(fileURLWithPath: book.path))
                                }){
                                    Text("Open source in Finder")
                                }
                                Button(action: {
                                    OpenInTerminal(url: URL(fileURLWithPath: book.path))
                                }){
                                    Text("Open source in Terminal")
                                }
                                Divider()
                                Button(action: {
                                    OpenInFinder(url: URL(fileURLWithPath: "\(pathExport)/\(book.author)/\(book.title)"))
                                }){
                                    Text("Open export in Finder")
                                }.disabled(!DoesFileExists(url: URL(fileURLWithPath: "\(pathExport)/\(book.author)/\(book.title)")))
                            }
                        }
                        .animation(.linear(duration: 0.2))
                    }
                }
            }
        }
    }
}

// MARK: - View: BookListHeader

// The header of the book list

struct BookListHeader: View {
    let author: AuthorList
    // START body
    var body: some View {
        ZStack {
            /// FancyBackground().opacity(0.9)
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

// MARK: - View: BookListRow

// A row in the book list

struct BookListRow: View {
    let book: BookItem
    /// Get the list of books
    @EnvironmentObject var books: Books
    @State private var hovered = false
    // START body
    var body: some View {
        HStack {
            if ((book.cover) != nil) {
                Image(nsImage: GetCover(cover: book.cover!.path))
                    .CoverImageModifier(hovered: hovered)
            } else {
                ZStack {
                    Image(nsImage: NSImage(named: "CoverArt")!)
                        .CoverImageModifier(hovered: hovered)
                    Text(book.title)
                        .padding(.trailing, 10)
                        .frame(width: 60.0, height: 90.0)
                        .font(.caption2)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                }
            }
            VStack(alignment: .leading) {
                Text(book.title).fontWeight(.bold).lineLimit(2)
                Text(book.author)
                if !book.belongsToCollection.isEmpty {
                    Text("\(book.belongsToCollection) \(book.groupPositionRoman)")
                        .font (.caption)
                }
                Text("\(book.description) • " + book.date.prefix(4))
                    .font(.caption)
                    .foregroundColor(Color.secondary)
                if (book.type == .collection) {
                    let filterbooks = books.bookList.authors.flatMap{$0.books}.filter{$0.addToCollection.contains(where: { $0.name == book.collection })}
                    VStack(alignment: .leading) {
                        ForEach(filterbooks) { list in
                            Text(list.title)
                        }
                    }
                    .font(.caption2)
                }
            }
        }
        .padding(8)
        .onHover { isHovered in
            self.hovered = isHovered
        }
        .help(
            GetHoverHelp(book)
        )
        .animation(.default, value: hovered)
    }
}

//  MARK: - Extension: Modify BookListRow

/// The cover layout.

extension Image {
    func CoverImageModifier(hovered: Bool) -> some View {
        self
            .resizable().frame(width: 60.0, height: 90.0)
            .shadow(color: .init(red: 0, green: 0, blue: 0, opacity: 0.4), radius: 2, x: 2, y: 2)
            .padding(.trailing, 10)
            .padding(.leading, 0)
            .scaleEffect(hovered ? 1.1 : 1.0)
   }
}

// MARK: - NSViewRepresentable: SearchField

// A searchfield on top of the book list

struct SearchField: NSViewRepresentable {
    @Binding var text: String
    /// Get the list of books
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

// MARK: - Extension: SearchField

// Hide the focus ring

extension NSSearchField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
