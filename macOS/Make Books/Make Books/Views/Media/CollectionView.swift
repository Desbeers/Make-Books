//
//  CollectionView.swift
//  Make Books
//
//  Created by Nick Berendsen on 18/11/2023.
//

import SwiftUI

struct CollectionView: View {
    let collection: Collection
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    var body: some View {
        ScrollView {
            BookView(book: collection.book)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(collection.books) { book in
                        Button(
                            action: {
                                scene.navigationStack.append(.book(book: book))
                            },
                            label: {
                                BookCover.Cover(book: book)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 100)
                                    .cornerRadius(6)
                            }
                        )
                    }
                }
            }
            .padding()
            .buttonStyle(.plain)
        }
    }
}
