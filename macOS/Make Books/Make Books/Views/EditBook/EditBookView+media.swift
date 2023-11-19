//
//  EditBookView+media.swift
//  Make Books
//
//  Created by Nick Berendsen on 04/09/2023.
//

import SwiftUI

extension EditBookView {

    var media: some View {
        Section("Media") {

            // MARK: Media

            Picker(
                selection: $values.media,
                content: {
                    ForEach(Media.create, id: \.self) { media in
                        Text(media.label)
                            .tag(media)
                    }
                },
                label: {
                    Text(Metadata.media.label)
                }
            )
            .disabled(values.status == .existing)
            if values.media == .collection {
                Form {

                    // MARK: Collection

                    TextField(text: bind($values.collection, default: ""), prompt: Text(Metadata.collection.empty)) {
                        Text(Metadata.collection.label)
                    }
                    .focused($focus, equals: .collection)
                    CollectionBooks(book: values)
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            if values.media == .tag {
                Form {

                    // MARK: Tag

                    TextField(text: bind($values.tag, default: ""), prompt: Text(Metadata.tag.empty)) {
                        Text(Metadata.tag.label)
                    }
                    .focused($focus, equals: .tag)
                }
                .padding()
                .background(.ultraThinMaterial)
            }

            // MARK: Chapter style

            Picker(
                selection: bind($values.chapterStyle, default: .thatcher),
                content: {
                    ForEach(Book.ChapterStyle.allCases, id: \.self) { style in
                        Text(style.label)
                            .tag(style)
                    }
                },
                label: {
                    Text(Metadata.chapterStyle.label)
                }
            )
        }
    }
}
