//
//  EditBookView+series.swift
//  Make Books
//
//  Created by Nick Berendsen on 04/09/2023.
//

import SwiftUI

extension EditBookView {

    var series: some View {

        Section(
            content: {

                // MARK: Belong to serie

                TextField(text: bind($values.belongsToSerie, default: ""), prompt: Text(Metadata.belongsToSerie.empty)) {
                    Text(Metadata.belongsToSerie.label)
                }
                .focused($focus, equals: .belongsToSerie)
                .suggestions(
                    focus: focus == .belongsToSerie,
                    suggestions: Array(Set(library.books.compactMap(\.belongsToSerie))).sorted(),
                    value: bind($values.belongsToSerie, default: "")
                )
                if let serie = values.belongsToSerie, !serie.isEmpty {
                    Form {
                        // MARK: Serie position

                        Picker(
                            selection: bind($values.seriePosition, default: 1),
                            content: {
                                ForEach(1 ... 100, id: \.self) { index in
                                    Text("Serie number \(index)")
                                        .tag(index)
                                }
                            },
                            label: {
                                Text(Metadata.seriePosition.label)
                            }
                        )
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                }
            },
            header: {
                Text("Series")
                    .font(.title)
            }
        )
    }
}
