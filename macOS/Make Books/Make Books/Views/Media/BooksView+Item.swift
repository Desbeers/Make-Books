//
//  BooksView+Item.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

extension BooksView {

    /// SwiftUI `View` for a Book in a list
    struct Item: View {
        /// The Book to show
        let book: Book
        /// The body of the `View`
        var body: some View {
            ZStack(alignment: .bottomTrailing) {
                BookCover.Cover(book: book)
                Image(systemName: icon)
                    .font(.title)
                    .padding(4)
                    .cornerRadius(StaticSetting.cornerRadius)
                    .background(.ultraThinMaterial)
            }
            .overlay(alignment: .bottomLeading) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(book.hasBeenRead ?? false ? .green : .clear)
            }
            .cornerRadius(StaticSetting.cornerRadius)
            .frame(
                width: StaticSetting.coverSize.width,
                height: StaticSetting.coverSize.height
            )
        }
        /// The SF symbol string for the media
        var icon: String {
            switch book.media {
            case .collection:
                return "square.stack"
            case .tag:
                return "tag"
            default:
                return "book"
            }
        }
    }
}
