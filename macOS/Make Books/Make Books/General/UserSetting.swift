//
//  Setting.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import Foundation
import SwiftlyFolderUtilities

/// User settings for Make Books
enum UserSetting: String {

    // MARK: UserDefaults strings

    /// The export folder
    case exportFolder = "ExportFolder"
    /// The books folder
    case booksFolder = "BooksFolder"
    /// The folder for a new book
    case newBookFolder = "NewBookFolder"
    /// The PDF paper format
    case paper = "Paper"
    /// The PDF font size
    case font = "Font"
    /// The collection display mode
    case collectionDisplayMode = "CollectionDisplayMode"

    // MARK: Folder Bookmarks strings

    /// Get the selected export foder
    static var getExportFolder = FolderBookmark.getLastSelectedURL(bookmark: UserSetting.exportFolder.rawValue).path(percentEncoded: false)
    /// Get the selected books foder
    static var getBooksFolder = FolderBookmark.getLastSelectedURL(bookmark: UserSetting.booksFolder.rawValue).path(percentEncoded: false)

    // MARK: Paper formats

    /// Paper formats
    enum PaperFormat: String, CaseIterable {
        /// ebook format
        case ebook
        /// A4 format
        case a4paper
        /// A5 format
        case a5paper
        /// The label for the paper
        var label: String {
            switch self {
            case .ebook:
                return "US trade (6 by 9 inch)"
            case .a4paper:
                return "A4 paper"
            case .a5paper:
                return "A4 paper"
            }
        }
    }

    // MARK: Font sizes

    /// Font sizes
    enum FontSize: String, CaseIterable {
        /// 10 pt font size
        case size10 = "10pt"
        /// 11 pt font size
        case size11 = "11pt"
        /// 12 pt font size
        case size12 = "12pt"
        /// 14 pt font size
        case size14 = "14pt"
        /// The label for the font
        var label: String {
            switch self {
            case .size10:
                return "10 points"
            case .size11:
                return "11 points"
            case .size12:
                return "12 points"
            case .size14:
                return "14 points"
            }
        }
    }

    // MARK: Make options

    /// Get all options for Make
    /// - Returns: All options
    static var getMakeOptions: [MakeOption] {
        /// The options
        var options = [MakeOption]()
        options.append(MakeOption(
            make: "clean",
            utilities: [.pandoc, .font],
            label: "Clean all files before processing",
            description: "Be carefull, all exports will be removed!",
            isSelected: false)
        )
        options.append(MakeOption(
            make: "pdf",
            utilities: [.pandoc, .font, .lualatex],
            label: "Make a PDF",
            description: "A PDF ment for screen, with cover and a coloured background. Good for reading on screen.",
            isSelected: false)
        )
        options.append(MakeOption(
            make: "print",
            utilities: [.pandoc, .font, .lualatex],
            label: "Make a printable file",
            description: "This is also a PDF, however, no cover and has a white background. Good for printing.",
            isSelected: false)
        )
        options.append(MakeOption(
            make: "epub",
            utilities: [.pandoc, .font],
            label: "Make an ePub book",
            description: "A modern ePub; ready for any reader that supports ePubs; like any reader should do.",
            isSelected: false)
        )
        options.append(MakeOption(
            make: "kobo",
            utilities: [.pandoc, .font, .kepubify],
            label: "Make a Kobo book",
            description: "Make an ePub that is optimised for the Kobo e-reader.",
            isSelected: false)
        )
        return options
    }
}
