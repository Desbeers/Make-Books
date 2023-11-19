//
//  SearchView.swift
//  Make Books
//
//  Created by Nick Berendsen on 29/07/2023.
//

import SwiftUI

/// SwiftUI `View` for search results
struct SearchView: View {
    /// The state of the Scene
    @EnvironmentObject var scene: SceneState
    /// The state of the Library
    @Environment(Library.self) private var library
    /// The books that we found
    @State private var books: [Book] = []
    var body: some View {
        Group {
            if books.isEmpty {
                ContentUnavailableView.search
            } else {
                BooksView(books: books)
            }
        }
        .animation(.default, value: books)
        .task(id: scene.searchQuery) {
            books = library.books
            if !scene.searchQuery.isEmpty {
                let searchMatcher = Search.Matcher(query: scene.searchQuery)
                books = books.filter { book in
                    return searchMatcher.matches(book.search)
                }
            }
        }
    }
}
