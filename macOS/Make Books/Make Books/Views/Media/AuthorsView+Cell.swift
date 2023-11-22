//
//  AuthorsView+Cell.swift
//  Make Books
//
//  Created by Nick Berendsen on 09/08/2023.
//

import SwiftUI

extension AuthorsView {
    struct Cell: View {
        /// The Author to show
        let author: Author
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        /// The body of the View
        var body: some View {
            Button(
                action: {
                    scene.navigationStack.append(.author(author: author))
                }, label: {
                    VStack(alignment: .leading) {
                        Text(author.name)
                        Text("^[\(author.books.count) \("Book")](inflect: true)")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .padding()
                }
            )
            .buttonStyle(.plain)
        }
    }
}
