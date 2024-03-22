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

                TextField(
                    text: $values.belongsToSerie,
                    prompt: Text(Metadata.belongsToSerie.empty)
                ) {
                    Text(Metadata.belongsToSerie.label)
                }
                .focused($focus, equals: .belongsToSerie)
                .suggestions(
                    focus: focus == .belongsToSerie,
                    suggestions: Array(Set(library.books.map(\.belongsToSerie))).sorted(),
                    value: $values.belongsToSerie
                )
                if !values.belongsToSerie.isEmpty {
                    Form {
                        // MARK: Serie position

                        Picker(
                            selection: $values.seriePosition,
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
                    .labelsHidden()
                }
            },
            header: {
                Text("Series")
                    .font(.title)
            }
        )
    }
}
