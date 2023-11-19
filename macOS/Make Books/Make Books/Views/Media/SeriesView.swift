//
//  SeriesView.swift
//  Make Books
//
//  Created by Nick Berendsen on 18/07/2023.
//

import SwiftUI

/// SwiftUI `View` for all series
struct SeriesView: View {
    /// The state of the Library
    @Environment(Library.self) private var library
    /// The body of the `View`
    var body: some View {
        ScrollCollectionView(
            collection: Dictionary(grouping: library.series) { serie in
                ScrollCollectionHeader(
                    sectionLabel: String(serie.title.prefix(1)),
                    indexLabel: String(serie.title.prefix(1)),
                    sort: String(serie.title.prefix(1))
                )
            }
                .sorted(using: KeyPathComparator(\.key.sort)),
            style: .asList,
            anchor: .top,
            header: { header in
                BooksView.Header(header: header)
            },
            cell: { index, serie in
                Cell(serie: serie)
                    .background(
                        Color.alternatedList.opacity(index % 2 == 1 ? 1 : 0)
                    )
            }
        )
    }
}
