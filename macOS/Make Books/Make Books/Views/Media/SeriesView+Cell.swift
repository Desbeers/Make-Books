//
//  SeriesView+Cell.swift
//  Make Books
//
//  Created by Nick Berendsen on 09/08/2023.
//

import SwiftUI

extension SeriesView {

    struct Cell: View {
        /// The Serie to show
        let serie: Serie
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        /// The body of the View
        var body: some View {
            Button(
                action: {
                    scene.navigationStack.append(.serie(serie: serie))
                }, label: {
                    VStack(alignment: .leading) {
                        Text(serie.title)
                        Text(serie.authors.joined(separator: " ∙ "))
                            .foregroundStyle(.secondary)
                        Text("\(serie.books.count) books")
                            .foregroundStyle(.tertiary)
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
