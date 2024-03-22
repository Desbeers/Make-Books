//
//  Router+DestinationView.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

extension Router {

    /// SwiftUI `View`with a `Router` destination in the `ContentView`
    struct DestinationView: View {
        /// The `Router` item
        let router: Router
        /// The state of the Library
        @Environment(Library.self) private var library
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        /// The body of the `View`
        var body: some View {
            switch router {
            case .books:
                BooksView(books: library.books)
            case .book(let book):
                ScrollView {
                    BookView(book: book)
                }
            case .series:
                SeriesView()
            case .serie(let serie):
                BooksView(books: serie.books)
            case .authors:
                AuthorsView()
            case .author(let author):
                BooksView(books: author.books)
            case .collections:
                BooksView(books: library.collections)
            case .collection(let collection):
                CollectionView(collection: collection)
            case .tags:
                BooksView(books: library.tags)
            case .tag(let tag):
                TagView(tag: tag)
            case .fileDropper:
                FileDropperView()
            case .search:
                SearchView()
            case .edit(let book):
                EditBookView(book: book)
            case .add:
                EditBookView(book: Book())
            }
        }
    }
}
