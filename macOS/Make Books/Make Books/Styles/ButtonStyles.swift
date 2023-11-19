//
//  ButtonStyles.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

extension Styles {

    // MARK: BookItem Button

    /// SwiftUI Button style for a KodiItem Button
    struct BookItemButton: ButtonStyle {
        /// The ``Book``
        let book: Book
        /// The SceneState model
        @EnvironmentObject var scene: SceneState
        /// The focus state
        @Environment(\.isFocused)
        var focused: Bool
        /// Bool if the item is selected
        var selected: Bool {
            book.id == scene.detailSelection.item.book?.id
        }
        /// Avoid error in the `View extension` when Strict Concurrency Checking is set to 'complete'
        nonisolated init(book: Book) {
            self.book = book
        }
        /// The body of the `ButtonStyle`
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .brightness(configuration.isPressed ? 0.1 : 0)
                .scaleEffect(selected ? 1.05 : 1)
                .animation(.easeIn(duration: 0.1), value: selected)
        }
    }
}

extension ButtonStyle where Self == Styles.BookItemButton {

    /// Button style for a 'BookItem' button
    static func bookItemButton(book: Book) -> Styles.BookItemButton { .init(book: book) }
}

extension Styles {

    /// Button style for a 'alternating' list button
    struct AlternateButton: ButtonStyle {
        /// The `index` of the button
        let index: Int
        /// The body of the `ButtonStyle`
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(StaticSetting.cornerRadius)
                .frame(maxWidth: .infinity, alignment: .leading)
                .brightness(configuration.isPressed ? 0.1 : 0)
                .background(Color(nsColor: .textBackgroundColor).opacity(index % 2 == 0 ? 1 : 0.5))
        }
    }
}

extension ButtonStyle where Self == Styles.AlternateButton {

    /// Button style for a 'alternating' list button
    static func alternateButton(index: Int) -> Styles.AlternateButton { .init(index: index) }
}
