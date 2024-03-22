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
        /// The state of the Library
        @Environment(Library.self) private var library
        /// The body of the `View`
        var body: some View {
            Form {
                LabeledDetail(
                    title: Metadata.title.label,
                    value: book.title
                )
                LabeledDetail(
                    title: Metadata.author.label,
                    value: book.author
                )
                LabeledDetail(
                    title: Metadata.subject.label,
                    value: book.subject,
                    empty: Metadata.subject.empty
                )
                LabeledDetail(
                    title: Metadata.description.label,
                    value: book.description,
                    empty: Metadata.description.empty
                )
                LabeledDetail(
                    title: Metadata.date.label,
                    value: StaticSetting.bookDateFormatter
                        .date(from: book.date)?.formatted(date: .long, time: .omitted) ?? "",
                    empty: Metadata.date.empty
                )
                LabeledDetail(
                    title: Metadata.revision.label,
                    value: book.revision,
                    empty: Metadata.revision.empty
                )
                LabeledDetail(
                    title: Metadata.rights.label,
                    value: book.rights,
                    empty: Metadata.rights.empty
                )
                LabeledDetail(
                    title: Metadata.publisher.label,
                    value: book.publisher,
                    empty: Metadata.publisher.empty
                )
                let countryName = Locale.current.localizedString(forIdentifier: book.language)
                LabeledDetail(
                    title: Metadata.language.label,
                    value: countryName ?? "",
                    empty: Metadata.language.empty
                )
                LabeledDetail(
                    title: Metadata.belongsToSerie.label,
                    value: book.serie,
                    empty: Metadata.belongsToSerie.empty,
                    router: library.getSerieLink(book: book)
                )
                Divider()
                LabeledDetail(
                    title: Metadata.hasBeenRead.label,
                    value: book.hasBeenRead ? "Yes" : "No"
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
        /// The message when the value is empty
        var empty = "Not available"

        var router: Router?

        /// The state of the Scene
        @Environment(SceneState.self) private var scene

        /// The body of the `View`
        var body: some View {
            LabeledContent(
                content: {
                    if let router {
                        Button(value) {
                            scene.navigationStack.append(router)
                        }
                    } else {
                        Text(value.isEmpty ? empty : value)
                            .foregroundStyle(value.isEmpty ? .secondary : .primary)
                    }
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
