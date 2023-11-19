//
//  Router+item.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

extension Router {

    /// Structure for a ``Router`` Item
    struct Item: Identifiable {
        /// The ID of the item
        var id: String
        /// Title of the item
        var title: String = "Title"
        /// Description of the item
        var description: String = "Description"
        /// Loading message of the item
        var loading: String = "Loading"
        /// Message when the item is empty
        var empty: String = "Empty"
        /// The SF symbol for the item
        var icon: String = "square.dashed"
        /// The color of the item
        var color: Color = Color("AccentColor")
        /// The optional selected book
        var book: Book?
        /// The default sorting
        var defaultSort: Sort = Sort(id: "default", method: .title, order: .ascending)
    }
}

extension Router {
    /// Details of the router item
    var item: Item {
        switch self {
        case .books:
            return Item(
                id: "allBooks",
                title: "All Books",
                description: "View all your Books",
                loading: "Loading your Books",
                empty: "You have no Books",
                icon: "book",
                color: Color.accentColor
            )
        case .book(let book):
            return Item(
                id: "book+\(book.title)",
                title: "\(book.title)",
                description: "\(book.author)",
                loading: "Loading your Book",
                empty: "Your Book was not found",
                icon: "book",
                color: Color.accentColor,
                book: book
            )
        case .series:
            return Item(
                id: "allSeries",
                title: "All Series",
                description: "View all your Series",
                loading: "Loading your Series",
                empty: "You have no Series",
                icon: "list.bullet",
                color: Color.accentColor
            )
        case .serie(let serie):
            let description = (serie.authors + ["\(serie.books.count) books"]).joined(separator: " ∙ ")
            return Item(
                id: "serie+\(serie.title)",
                title: "\(serie.title)",
                description: "\(description)",
                loading: "Loading your Serie",
                empty: "Your Book was not found",
                icon: "list.bullet",
                color: Color.accentColor,
                defaultSort: Sort(method: .date, order: .ascending)
            )
        case .authors:
            return Item(
                id: "allAuthors",
                title: "All Authors",
                description: "View all your Authors",
                loading: "Loading your Authors",
                empty: "You have no Authors",
                icon: "person.2",
                color: Color.accentColor
            )
        case .author(let author):
            let count = author.books.count
            return Item(
                id: "author+\(author.name)",
                title: "\(author.name)",
                description: ("\(count) \(count == 1 ? "Book" : "Books")"),
                loading: "Loading the books",
                empty: "No books found",
                icon: "person",
                color: Color.accentColor
            )
        case .collections:
            return Item(
                id: "allCollections",
                title: "All Collections",
                description: "View all your Collections",
                loading: "Loading your Collections",
                empty: "You have no Collections",
                icon: "square.stack",
                color: Color.accentColor
            )
        case .collection(let collection):
            return Item(
                id: "collection+\(collection.book.title)",
                title: "\(collection.book.title)",
                description: "A collection of \(collection.books.count) books",
                loading: "Loading your Collection",
                empty: "This Collection is empty",
                icon: "square.stack",
                color: Color.accentColor,
                book: collection.book
            )
        case .tags:
            return Item(
                id: "allTags",
                title: "All Tags",
                description: "View all your Tags",
                loading: "Loading your Tags",
                empty: "You have no Tags",
                icon: "tag",
                color: Color.accentColor
            )
        case .tag(let tag):
            return Item(
                id: "tag+\(tag.title)",
                title: "\(tag.title)",
                description: "All files with the `\(tag.tag ?? "ERROR")' tag",
                loading: "Loading files with your Tag",
                empty: "You have no files with this Tag",
                icon: "tag",
                color: Color.accentColor
            )
        case .fileDropper:
            return Item(
                id: "fileDropper",
                title: "File Dropper",
                description: "Drop a Markdown File for a quick convert to PDF",
                loading: "Converting your file",
                empty: "Something went wrong",
                icon: "tray.and.arrow.down",
                color: Color.accentColor
            )
        case .search:
            return Item(
                id: "search",
                title: "Search",
                description: "Search books in your library",
                loading: "Searching your library",
                empty: "Nothing found",
                icon: "magnifyingglass",
                color: Color.accentColor
            )
        case .edit(let book):
            return Item(
                id: "edit",
                title: "\(book.title)",
                description: "Edit the book",
                loading: "Edit the book",
                empty: "Book not found",
                icon: "pencil",
                color: Color.accentColor
            )
        case .add:
            return Item(
                id: "add",
                title: "New Book",
                description: "Add a new Book",
                loading: "Add a new Book",
                empty: "Add a new Book",
                icon: "square.and.pencil",
                color: Color.accentColor
            )
        }
    }
}
