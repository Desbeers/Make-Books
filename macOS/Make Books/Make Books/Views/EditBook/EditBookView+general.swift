//
//  EditBookView+general.swift
//  Make Books
//
//  Created by Nick Berendsen on 04/09/2023.
//

import SwiftUI

extension EditBookView {

    var general: some View {
        Section(
            content: {
                // MARK: Title

                TextField(text: $values.title, prompt: Text(Metadata.title.empty)) {
                    Text(Metadata.title.label)
                }
                .focused($focus, equals: .title)

                // MARK: Author

                TextField(text: $values.author, prompt: Text(Metadata.author.empty)) {
                    Text(Metadata.author.label)
                }
                .focused($focus, equals: .author)
                .suggestions(
                    focus: focus == .author,
                    suggestions: library.authors.map(\.name).sorted(),
                    value: $values.author
                )

                // MARK: Subject

                TextField(text: bind($values.subject, default: ""), prompt: Text(Metadata.subject.empty), axis: .vertical) {
                    Text(Metadata.subject.label)
                }
                .focused($focus, equals: .subject)
                .suggestions(
                    focus: focus == .subject,
                    suggestions: Array(Set(library.books.compactMap(\.subject))),
                    value: bind($values.subject, default: "")
                )

                // MARK: Description

                TextField(
                    text: bind($values.description, default: ""),
                    prompt: Text(Metadata.description.empty),
                    axis: .vertical
                ) {
                    Text(Metadata.description.label)
                }
                .focused($focus, equals: .description)

                // MARK: Language

                TextField(text: bind($values.language, default: ""), prompt: Text(Metadata.language.empty), axis: .vertical) {
                    Text(Metadata.language.label)
                }
                .focused($focus, equals: .language)
                .suggestions(
                    focus: focus == .language,
                    suggestions: Array(Set(library.books.compactMap(\.language))),
                    value: bind($values.language, default: "")
                )

                // MARK: Date

                TextField(text: bind($values.date, default: ""), prompt: Text(Metadata.date.empty)) {
                    Text(Metadata.date.label)
                }
                .focused($focus, equals: .date)

                // MARK: Revision

                TextField(text: bind($values.revision, default: ""), prompt: Text(Metadata.revision.empty)) {
                    Text(Metadata.revision.label)
                }
                .focused($focus, equals: .revision)

                // MARK: Rights

                TextField(text: bind($values.rights, default: ""), prompt: Text(Metadata.rights.empty), axis: .vertical) {
                    Text(Metadata.rights.label)
                }
                .focused($focus, equals: .rights)
                .suggestions(
                    focus: focus == .rights,
                    suggestions: Array(Set(library.books.compactMap(\.rights))),
                    value: bind($values.rights, default: "")
                )

                // MARK: Publisher

                TextField(text: bind($values.publisher, default: ""), prompt: Text(Metadata.publisher.empty)) {
                    Text(Metadata.publisher.label)
                }
                .focused($focus, equals: .publisher)
                .suggestions(
                    focus: focus == .publisher,
                    suggestions: Array(Set(library.books.compactMap(\.publisher))),
                    value: bind($values.publisher, default: "")
                )

                // MARK: Read

                Toggle(isOn: bind($values.hasBeenRead, default: false)) {
                    Text(Metadata.hasBeenRead.label)
                    Text(Metadata.hasBeenRead.description)
                }
            },
            header: {
                Text("General")
                    .font(.title)
            }
        )


//        Section("General") {
//
//            // MARK: Title
//
//            TextField(text: $values.title, prompt: Text(Metadata.title.empty)) {
//                Text(Metadata.title.label)
//            }
//            .focused($focus, equals: .title)
//
//            // MARK: Author
//
//            TextField(text: $values.author, prompt: Text(Metadata.author.empty)) {
//                Text(Metadata.author.label)
//            }
//            .focused($focus, equals: .author)
//            .suggestions(
//                focus: focus == .author,
//                suggestions: library.authors.map(\.name).sorted(),
//                value: $values.author
//            )
//
//            // MARK: Subject
//
//            TextField(text: bind($values.subject, default: ""), prompt: Text(Metadata.subject.empty), axis: .vertical) {
//                Text(Metadata.subject.label)
//            }
//            .focused($focus, equals: .subject)
//            .suggestions(
//                focus: focus == .subject,
//                suggestions: Array(Set(library.books.compactMap(\.subject))),
//                value: bind($values.subject, default: "")
//            )
//
//            // MARK: Description
//
//            TextField(
//                text: bind($values.description, default: ""),
//                prompt: Text(Metadata.description.empty),
//                axis: .vertical
//            ) {
//                Text(Metadata.description.label)
//            }
//            .focused($focus, equals: .description)
//
//            // MARK: Language
//
//            TextField(text: bind($values.language, default: ""), prompt: Text(Metadata.language.empty), axis: .vertical) {
//                Text(Metadata.language.label)
//            }
//            .focused($focus, equals: .language)
//            .suggestions(
//                focus: focus == .language,
//                suggestions: Array(Set(library.books.compactMap(\.language))),
//                value: bind($values.language, default: "")
//            )
//
//            // MARK: Date
//
//            TextField(text: bind($values.date, default: ""), prompt: Text(Metadata.date.empty)) {
//                Text(Metadata.date.label)
//            }
//            .focused($focus, equals: .date)
//
//            // MARK: Revision
//
//            TextField(text: bind($values.revision, default: ""), prompt: Text(Metadata.revision.empty)) {
//                Text(Metadata.revision.label)
//            }
//            .focused($focus, equals: .revision)
//
//            // MARK: Rights
//
//            TextField(text: bind($values.rights, default: ""), prompt: Text(Metadata.rights.empty), axis: .vertical) {
//                Text(Metadata.rights.label)
//            }
//            .focused($focus, equals: .rights)
//            .suggestions(
//                focus: focus == .rights,
//                suggestions: Array(Set(library.books.compactMap(\.rights))),
//                value: bind($values.rights, default: "")
//            )
//
//            // MARK: Publisher
//
//            TextField(text: bind($values.publisher, default: ""), prompt: Text(Metadata.publisher.empty)) {
//                Text(Metadata.publisher.label)
//            }
//            .focused($focus, equals: .publisher)
//            .suggestions(
//                focus: focus == .publisher,
//                suggestions: Array(Set(library.books.compactMap(\.publisher))),
//                value: bind($values.publisher, default: "")
//            )
//        }
    }
}
