//
//  MakeOptionsModel.swift
//  Make Books
//
//  Copyright © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyFolderUtilities
import SwiftlyTerminalUtilities

// MARK: ObservableObject: MakeOptions

/// The class with options for Make
final class MakeOptions: ObservableObject {
    @Published var options: [MakeOption] = getOptions

    @Published var utilities: [Utility] = []
    @Published var notAvailable: [String] = []

    @AppStorage("pdfFont") var pdfFont: String = "11pt"
    @AppStorage("pdfPaper") var pdfPaper: String = "ebook"

    var pathBooks: String {
        FolderBookmark.getLastSelectedURL(bookmark: "BooksPath").path(percentEncoded: false)
    }
    var pathExport: String {
        FolderBookmark.getLastSelectedURL(bookmark: "ExportPath").path(percentEncoded: false)
    }

    init() {
        Task {
            await checkUtilities()
        }
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
    static var getOptions: [MakeOption] {
        var options = [MakeOption]()
        /// The options
        options.append(MakeOption(make: "clean",
                                  utilities: [.pandoc],
                                  label: "Clean all files before processing",
                                  text: "Be carefull, all exports will be removed!",
                                  isSelected: false)
        )
        options.append(MakeOption(make: "pdf",
                                  utilities: [.pandoc, .lualatex],
                                  label: "Make a PDF",
                                  text: "A PDF ment for screen, with cover and a coloured background. Good for reading on screen.",
                                  isSelected: true)
        )
        options.append(MakeOption(make: "print",
                                  utilities: [.pandoc, .lualatex],
                                  label: "Make a printable file",
                                  text: "This is also a PDF, however, no cover and has a white background. Good for printing.",
                                  isSelected: false)
        )
        options.append(MakeOption(make: "epub",
                                  utilities: [.pandoc],
                                  label: "Make an ePub book",
                                  text: "A modern ePub; ready for any reader that supports ePubs; like any reader should do.",
                                  isSelected: false)
        )
        options.append(MakeOption(make: "kobo",
                                  utilities: [.pandoc, .kepubify],
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
    var utilities: [Utility]
    var label: String
    var text: String
    var isSelected: Bool
}

extension MakeOptions {

    @MainActor func checkUtilities() async {
        for utility in Utility.allCases {
            if let location = await Terminal.which(utility.rawValue) {
                utilities.append(utility)
            } else {
                notAvailable.append(utility.notAvailable)
            }
        }
    }

    func available( _ option: MakeOption) -> Bool {
        option.utilities.allSatisfy(utilities.contains)
    }
}
