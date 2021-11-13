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
    @AppStorage("pathExport") var pathExport: String = getDocumentsDirectory()
    // START body
    var body: some View {
        VStack {
            List(selection: $books.bookSelected) {
                ForEach(books.bookList.authors) { author in
                    Section(header: Text(author.name)) {
                        ForEach(author.books.filter({search.isEmpty ? true : $0.search.localizedCaseInsensitiveContains(search)}), id: \.self) { book in
                            BookListRow(book: book)
                                .contextMenu {
                                    Button {
                                        openInFinder(url: URL(fileURLWithPath: book.path))
                                    } label: {
                                        Text("Open source in Finder")
                                    }
                                    Button {
                                        openInTerminal(url: URL(fileURLWithPath: book.path))
                                    } label: {
                                        Text("Open source in Terminal")
                                    }
                                    Divider()
                                    Button {
                                        openInFinder(url: URL(fileURLWithPath: "\(pathExport)/\(book.author)/\(book.title)"))
                                    } label: {
                                        Text("Open export in Finder")
                                    }
                                    .disabled(!doesFileExists(url: URL(fileURLWithPath: "\(pathExport)/\(book.author)/\(book.title)")))
                                }
                        }
                        .animation(.linear(duration: 0.2), value: books.bookSelected)
                    }
                }
            }
            .searchable(text: $search, placement: .sidebar)
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
            if book.cover != nil {
                Image(nsImage: getCover(cover: book.cover!.path))
                    .coverImageModifier(hovered: hovered)
            } else {
                ZStack {
                    Image("CoverArt")
                        .coverImageModifier(hovered: hovered)
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
                        .font(.caption)
                }
                Text("\(book.description) • " + book.date.prefix(4))
                    .font(.caption)
                    .foregroundColor(Color.secondary)
                if book.type == .collection {
                    /// List all the books in this collection
                    let filterbooks = books.bookList.authors.flatMap { $0.books }
                        .filter { $0.addToCollection.contains(where: { $0.name == book.collection })}
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
            book.help
        )
        .animation(.default, value: hovered)
    }
}

// MARK: - Extension: Modify BookListRow

/// The cover layout.

extension Image {
    func coverImageModifier(hovered: Bool) -> some View {
        self
            .resizable().frame(width: 60.0, height: 90.0)
            .shadow(color: .init(red: 0, green: 0, blue: 0, opacity: 0.4), radius: 2, x: 2, y: 2)
            .padding(.trailing, 10)
            .padding(.leading, 0)
            .scaleEffect(hovered ? 1.1 : 1.0)
   }
}
