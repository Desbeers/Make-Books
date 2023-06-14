//  BooksView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

/// SwiftUI View  for all the books
struct BooksView: View {
    /// Get the list of books
    @EnvironmentObject var books: Books
    @State var search: String = ""
    var body: some View {
        List(selection: $books.selectedBook) {
            if search.isEmpty {
                ForEach(books.authorList) { author in
                    Section(header: Text(author.name)) {
                        ForEach(author.books, id: \.self) { book in
                            Row(book: book)
                                .contextMenu {
                                    Buttons(book: book)
                                }
                        }
                    }
                }
            } else {
                ForEach(books.bookList.filter({$0.search.localizedCaseInsensitiveContains(search)}), id: \.self) { book in
                    Row(book: book)
                        .contextMenu {
                            Buttons(book: book)
                        }
                }
            }
        }
        .searchable(text: $search, prompt: "Search for book or author")
    }
}

extension BooksView {

    /// A row in the book list
    struct Row: View {
        let book: BookItem
        /// Get the list of books
        @EnvironmentObject var books: Books
        @State private var hovered = false
        /// The body of the View
        var body: some View {
            HStack {
                Group {
                    if let cover = book.coverURL {
                        Image(nsImage: getCover(cover: cover))
                            .resizable()
                    } else {
                        ZStack {
                            Image("CoverArt")
                                .resizable()
                            Text(book.title)
                                .font(.caption2)
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .frame(width: 60.0, height: 90.0)
                .shadow(radius: 2, x: 2, y: 2)
                VStack(alignment: .leading) {
                    Text(book.title)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    Group {
                        Text(book.author)
                        if let belongsToCollection = book.belongsToCollection {
                            Text("\(belongsToCollection) \(romanNumber(number: book.groupPosition))")
                                .font(.caption)
                        }
                        Text("\(book.description) • " + book.date.prefix(4))
                            .font(.caption)
                        if book.type == .collection {
                            /// List all the books in this collection
                            let filterbooks = books.authorList.flatMap { $0.books }
                                .filter { $0.addToCollection.contains(where: { $0.name == book.collection })}
                            VStack(alignment: .leading) {
                                ForEach(filterbooks) { list in
                                    Text(list.title)
                                }
                            }
                            .font(.caption2)
                        }
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
    }

    struct Buttons: View {
        /// The book item
        let book: BookItem
        /// The export path
        var pathExport: String {
            FolderBookmark.getURL(bookmark: "ExportPath").path(percentEncoded: false)
        }
        /// The body of the `View`
        var body: some View {
            Button {
                FolderBookmark.openInFinder(url: URL(fileURLWithPath: "\(pathExport)/\(book.author)/\(book.title)"))
            } label: {
                Text("Open export in Finder")
            }
            .disabled(!doesFileExists(url: URL(fileURLWithPath: "\(pathExport)/\(book.author)/\(book.title)")))
            Divider()
            Button {
                FolderBookmark.openInFinder(url: book.folderURL)
            } label: {
                Text("Open source in Finder")
            }
            Button {
                Terminal.openURL(url: book.folderURL)
            } label: {
                Text("Open source in Terminal")
            }
        }
    }
}
