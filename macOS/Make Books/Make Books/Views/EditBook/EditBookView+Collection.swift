//
//  EditBookView+Collection.swift
//  Make Books
//
//  Created by Nick Berendsen on 06/08/2023.
//

import SwiftUI

extension EditBookView {

    var belongsToCollections: some View {

        // MARK: Belongs to collections

        Section(
            content: {
                Toggle(isOn: $showCollections) {
                    Text("Add to collections")
                }

                if showCollections {
                    CollectionEdit(book: $values)
                }
            },
            header: {
                Text("Collections")
                    .font(.title)
            }
        )
    }

    struct CollectionBooks: View {
        let book: Book
        /// The state of the Library
        @Environment(Library.self) private var library

        @State private var books: [Book] = []

        var body: some View {
            LabeledContent("Books") {
                VStack(alignment: .leading) {
                    ForEach(books) { book in
                        Text(book.title)
                        Text(book.author)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .task(id: book.collection) {
                if let books = library.getCollectionBooks(collection: book) {
                    self.books = books
                }
            }
        }
    }

    struct CollectionEdit: View {
        @Binding var book: Book

        /// The state of the Library
        @Environment(Library.self) private var library

        @State private var formItems: [Collection.Item] = []

        var body: some View {
            Form {
                ForEach($formItems) { $item in

                    HStack {
                        Toggle(isOn: $item.isSelected) {
                            Text(item.name)
                        }
                        Picker(
                            selection: $item.collectionPosition,
                            content: {
                                ForEach(1 ... 100, id: \.self) { index in
                                    Text("Collection number \(index)")
                                        .tag(index)
                                }
                            },
                            label: {
                                Text(Metadata.seriePosition.label)
                            }
                        )
                        .disabled(!item.isSelected)
                        .labelsHidden()
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .task(id: book.id) {
                findCollectionItems()
            }
            .task(id: formItems) {
                let items = formItems.filter { $0.isSelected }
                book.collectionItems = items
            }
        }

        private func findCollectionItems() {
            let collectionTitles = library.collections.compactMap(\.collection)
            for title in collectionTitles {
                var item: Collection.Item = .init(name: title, collectionPosition: 1, isSelected: false)
                if let enabled = book.collectionItems.first(where: { $0.name == title }) {
                    item.isSelected = true
                    item.collectionPosition = enabled.collectionPosition
                }
                formItems.append(item)
            }
        }
    }
}
