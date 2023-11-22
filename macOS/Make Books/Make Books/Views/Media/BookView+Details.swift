//
//  BookView+Detail.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI
import SwiftlyFolderUtilities
import SwiftlyTerminalUtilities

extension BookView {

    /// SwiftUI `View` for ``Book`` details
    struct Details: View {
        /// The book to show
        let book: Book
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        /// The body of the `View`
        var body: some View {
            Form {
                Group {
                    LabeledDetail(
                        Metadata.title.label,
                        value: book.title
                    )
                    LabeledDetail(
                        Metadata.author.label,
                        value: book.author
                    )
                    LabeledDetail(
                        Metadata.subject.label,
                        value: book.subject ?? Metadata.subject.empty
                    )
                    LabeledDetail(
                        Metadata.description.label,
                        value: book.description ?? Metadata.description.empty
                    )
                }
                LabeledDetail(
                    Metadata.date.label,
                    value: book.date ?? Metadata.date.empty
                )
                LabeledDetail(
                    Metadata.revision.label,
                    value: book.revision ?? Metadata.revision.empty
                )
                LabeledDetail(
                    Metadata.rights.label,
                    value: book.rights ?? Metadata.rights.empty
                )
                LabeledDetail(
                    Metadata.publisher.label,
                    value: book.publisher ?? Metadata.publisher.empty
                )
                let countryName = Locale.current.localizedString(forLanguageCode: book.language ?? "")
                LabeledDetail(
                    Metadata.language.label,
                    value: countryName ?? Metadata.language.empty
                )
                LabeledDetail(
                    Metadata.belongsToSerie.label,
                    value: book.serie
                )
                LabeledDetail(
                    Metadata.hasBeenRead.label,
                    value: book.hasBeenRead ?? false ? "Yes" : "No"
                )
                .formStyle(.columns)
            }
        }
    }
}

extension BookView {

    /// SwiftUI `View` for a metadata detail
    struct LabeledDetail: View {
        /// The title of the metadata
        let title: String
        /// The value of the metadata
        let value: String
        /// Init the `View`
        init(_ title: String, value: String) {
            self.title = title
            self.value = value
        }
        /// The body of the `View`
        var body: some View {
            LabeledContent(
                content: {
                    Text(value)
                },
                label: {
                    Text("\(title):")
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
                }
            )
            .padding([.horizontal])
        }
    }
}
