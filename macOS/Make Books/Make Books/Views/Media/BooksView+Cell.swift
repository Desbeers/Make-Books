//
//  BooksView+Cell.swift
//  Make Books
//
//  Created by Nick Berendsen on 09/08/2023.
//

import SwiftUI

extension BooksView {

    struct Cell: View {
        /// The Book to show
        let book: Book
        /// Bool to show the books in a grid or list
        @AppStorage(UserSetting.collectionDisplayMode.rawValue)
        var showAsList: Bool = false
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        /// The state of the Library
        @Environment(Library.self) private var library
        /// The body of the View
        var body: some View {
            Button(
                action: {
                    switch book.media {
                    case .book:
                        scene.navigationStack.append(.book(book: book))
                    case .collection:
                        scene.navigationStack.append(library.getCollectionLink(collection: book))
                    case .tag:
                        scene.navigationStack.append(.tag(tag: book))
                    default:
                        break
                    }
                }, label: {
                    HStack {
                        Item(book: book)
                            .padding(.horizontal, 10)
                            .padding(.vertical, showAsList ? 10 : 0)
                        if showAsList {
                            BookView.Details(book: book)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                        }
                    }
                }
            )
            .padding()
            .buttonStyle(.plain)
        }
    }
}
