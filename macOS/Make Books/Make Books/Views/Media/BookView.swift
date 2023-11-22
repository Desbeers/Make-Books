//
//  BookView.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

/// SwiftUI `View` for a ``Book``
struct BookView: View {
    let book: Book
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text(.init(scene.detailSelection.item.title))
                    .font(.largeTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 40)
                Text(.init(scene.detailSelection.item.description))
                    .font(.title3)
            }
            .padding(.horizontal, 60)
            .padding()
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Image(systemName: scene.detailSelection.item.icon)
                    .font(.system(size: 40))
                    .padding(.leading)
            }
            .background(.thinMaterial)
            .cornerRadius(StaticSetting.cornerRadius)
            .padding([.top, .horizontal])
            Spacer()
            HStack {
                BookCover.Cover(book: book)
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200)
                    .cornerRadius(StaticSetting.cornerRadius)
                BookView.Details(book: book)
            }
            .padding()
            HStack {
                Button {
                    scene.showInspector.toggle()
                } label: {
                    Label("Preview PDF", systemImage: scene.showInspector ? "eye.fill" : "eye")
                }
                .disabled(book.pdfPreviewURL == nil)
                Button {
                    scene.navigationStack.append(.edit(book: book))
                } label: {
                    Label("Edit book", systemImage: "pencil")
                }
                Menu {
                    Button {
                        book.sourceURL.openInFinder()
                    } label: {
                        Text("Open source in Finder")
                    }
                    Button {
                        book.sourceURL.openInTerminal()
                    } label: {
                        Text("Open source in Terminal")
                    }
                } label: {
                    Label(title: {
                        Text("Open export in Finder")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }, icon: {
                        Image(systemName: "folder")
                    })
                } primaryAction: {
                    book.exportFolderURL.openInFinder()
                }
                .frame(maxWidth: 200)
            }
            .padding()
            Spacer()
        }
        .task(id: book) {
            if let previewURL = book.pdfPreviewURL {
                scene.previewURL = SceneState.PreviewURL(url: previewURL)
            } else {
                scene.previewURL = nil
            }
        }
    }
}
