//
//  StaticSetting.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

/// Static settings for Make Books
enum StaticSetting {

    /// The Make Book config files
    static let makeBooksConfigFiles = ["make-book.md", "make-collection.md", "make-tag-book.md"]

    /// Define the grid layout
    static let grid = [GridItem(.adaptive(minimum: 140))]

    /// The default size of cover art
    static let coverSize = CGSize(width: 140, height: 210)

    /// The default corner radius
    static let cornerRadius: Double = 6

    /// The `DateFormatter` for a book
    static var bookDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
}
