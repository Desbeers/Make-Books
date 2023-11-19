//
//  Book+ChapterStyle.swift
//  Make Books
//
//  Created by Nick Berendsen on 24/07/2023.
//

import Foundation

extension Book {

    /// The style for a chapter
    enum ChapterStyle: String, CaseIterable, Codable {
        /// `Thatcher` style (default)
        case thatcher
        /// `Plain` style
        case plain
        /// The label for the style
        var label: String {
            switch self {
            case .thatcher:
                return "Default style"
            case .plain:
                return "Plain style"
            }
        }
    }
}
