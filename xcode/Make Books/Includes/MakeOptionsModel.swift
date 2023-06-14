//
//  MakeOptionsModel.swift
//  Make Books
//
//  Copyright © 2023 Nick Berendsen
//

import SwiftUI

// MARK: ObservableObject: MakeOptions

/// The class with options for Make
final class MakeOptions: ObservableObject {
    @Published var options: [MakeOption]

    @AppStorage("pdfFont") var pdfFont: String = "11pt"
    @AppStorage("pdfPaper") var pdfPaper: String = "ebook"

    var pathBooks: String {
        FolderBookmark.getURL(bookmark: "BooksPath").path(percentEncoded: false)
    }
    var pathExport: String {
        FolderBookmark.getURL(bookmark: "ExportPath").path(percentEncoded: false)
    }

    init() {
        self.options = Self.getOptions()
    }
}

extension MakeOptions {

    /// The arguments for Make
    /// - Returns: A String with all arguments
    var arguments: String {
        var makeArgs = "--gui mac "
        makeArgs += "--paper " + pdfPaper + " "
        makeArgs += "--font " + pdfFont + " "
        makeArgs += "--books \"" + pathBooks + "\" "
        makeArgs += "--export \"" + pathExport + "\" "
        for option in options where option.isSelected == true {
            makeArgs += " " + option.make + " "
        }
        return (makeArgs)
    }
}

extension MakeOptions {

    /// Get all options for Make
    /// - Returns: All options
    static func getOptions() -> [MakeOption] {
        var options = [MakeOption]()
        /// The options
        options.append(MakeOption(make: "clean",
                                  label: "Clean all files before processing",
                                  text: "Be carefull, all exports will be removed!",
                                  isSelected: false)
        )
        options.append(MakeOption(make: "pdf",
                                  label: "Make a PDF",
                                  text: "A PDF ment for screen, with cover and a coloured background. Good for reading on screen.",
                                  isSelected: true)
        )
        options.append(MakeOption(make: "print",
                                  label: "Make a printable file",
                                  text: "This is also a PDF, however, no cover and has a white background. Good for printing.",
                                  isSelected: false)
        )
        options.append(MakeOption(make: "epub",
                                  label: "Make an ePub book",
                                  text: "A modern ePub; ready for any reader that supports ePubs; like any reader should do.",
                                  isSelected: false)
        )
        options.append(MakeOption(make: "kobo",
                                  label: "Make a Kobo book",
                                  text: "Make an ePub that is optimised for the Kobo e-reader.",
                                  isSelected: false)
        )
        return options
    }
}

// MARK: struct

/// The structure of a Make option
struct MakeOption: Identifiable {
    var id = UUID()
    var make: String
    var label: String
    var text: String
    var isSelected: Bool
}
