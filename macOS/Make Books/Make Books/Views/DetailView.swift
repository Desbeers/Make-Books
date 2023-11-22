//
//  DetailView.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

/// SwiftUI `View` for details of an item
struct DetailView: View {
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    /// The state of the Library
    @Environment(Library.self) private var library
    /// The state of Search
    @Environment(\.isSearching)
    private var isSearching
    /// The body of the `View`
    var body: some View {
        VStack {
            switch scene.detailSelection {
            case .books:
                OptionsView(books: library.books)
            case .book(let book):
                OptionsView(books: [book])
            case .serie(let serie):
                OptionsView(books: serie.books)
            case .collections:
                OptionsView(books: library.collections)
            case .collection(let collection):
                OptionsView(books: [collection.book])
            case .tags:
                OptionsView(books: library.tags)
            case .tag(let tag):
                OptionsView(books: [tag])
            case .author(let author):
                OptionsView(books: author.books)
            case .fileDropper:
                FileDropperView
                    .Details()
            default:
                Image(systemName: scene.detailSelection.item.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: .infinity)
                    .foregroundColor(.secondary)
                    .opacity(0.4)
                    .padding(40)
            }
        }
        .frame(maxHeight: .infinity)
        .padding()
        .task(id: scene.searchQuery) {
            withAnimation {
                if isSearching {
                    if scene.mainSelection != .search || !scene.navigationStack.isEmpty {
                        scene.mainSelection = .search
                        scene.navigationStack = []
                    }
                }
            }
        }
    }
}
