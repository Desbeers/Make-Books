//
//  BookView.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI
import SwiftlyFolderUtilities

/// SwiftUI `View` for a ``Book``
struct BookView: View {
    let book: Book
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    /// The state of the Library
    @Environment(Library.self) private var library
    /// The state of Make
    @Environment(MakeState.self) private var make

    @State private var haveExport: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            BookView.Header()
            HStack {
                BookCover.Cover(book: book)
                    .aspectRatio(contentMode: .fit)
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 3
                    }
                    .cornerRadius(StaticSetting.cornerRadius)
                BookView.Details(book: book)
            }
            .padding()
            HStack {
                Button {
                    scene.navigationStack.append(.edit(book: book))
                } label: {
                    Label("Edit book", systemImage: "pencil")
                }
                Button {
                    book.exportFolderURL.openInFinder()
                } label: {
                    Label("Open export in Finder", systemImage: "folder")
                }
                .disabled(!haveExport)
                Menu {
                    Button {
                        book.sourceURL.openInTerminal()
                    } label: {
                        Text("Open source in Terminal")
                    }
                } label: {
                    Label(title: {
                        Text("Open source in Finder")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }, icon: {
                        Image(systemName: "folder")
                    })
                } primaryAction: {
                    book.sourceURL.openInFinder()
                }
                .frame(maxWidth: 200)
            }
            .padding()

            if !book.collectionItems.isEmpty {
                Text("Collections containing '\(book.title)':")
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(book.collectionItems) { item in
                            if let collection = library.books.first(where: { $0.collection == item.name }) {
                                Button(
                                    action: {
                                        scene.navigationStack.append(library.getCollectionLink(collection: collection))
                                    },
                                    label: {
                                        BookCover.Cover(book: collection)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 100)
                                            .cornerRadius(6)
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .buttonStyle(.plain)
            }
        }
        .task(id: book) {
            if let previewURL = book.pdfPreviewURL {
                scene.previewURL = SceneState.PreviewURL(url: previewURL)
            } else {
                scene.previewURL = nil
            }
        }
        .task(id: make.scriptIsRunning) {
            let export = FolderUtil.doesUrlExist(url: book.exportFolderURL)
            haveExport = export == nil ? false : true
        }
    }
}
