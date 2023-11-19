//
//  AuthorsView.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

/// SwiftUI `View` for all authors
struct AuthorsView: View {
//    /// The state of the Scene
//    @EnvironmentObject var scene: SceneState
    /// The state of the Library
    @Environment(Library.self) private var library
    /// The body of the `View`
    var body: some View {
        ScrollCollectionView(
            collection: Dictionary(grouping: library.authors) { author in
                ScrollCollectionHeader(
                    sectionLabel: String(author.sortName.prefix(1)),
                    indexLabel: String(author.sortName.prefix(1)),
                    sort: String(author.sortName.prefix(1))
                )
            }
                .sorted(using: KeyPathComparator(\.key.sort)),
            style: .asList,
            anchor: .top,
            header: { header in
                BooksView.Header(header: header)
            },
            cell: { index, author in
                Cell(author: author)
                    .background(
                        Color.alternatedList.opacity(index % 2 == 1 ? 1 : 0)
                    )
            }
        )
    }
}
