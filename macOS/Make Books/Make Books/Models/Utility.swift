//
//  Utility.swift
//  Make Books
//
//  Created by Nick Berendsen on 21/07/2023.
//

import Foundation

/// Utilities needed by the scripts
enum Utility: String, CaseIterable {
    /// Check for `pandoc`
    case pandoc = "which pandoc"
    /// Check for `GreateVibes` font
    case font = "Great Vibes"
    /// Check for `lualatex`
    case lualatex = "which lualatex"
    /// Check for `kepubify`
    case kepubify = "which kepubify"

    static var terminal: [Utility] {
        [.pandoc, .lualatex, .kepubify]
    }
}

extension Utility {

    /// Text when an utility is not available
    var notAvailable: String {
        switch self {
        case .pandoc:
            return "**Pandoc** is not installed; *Make Books* needs it"
        case .font:
            return "**GreatVibes** font is not installed; *Make Books* needs it"
        case .lualatex:
            return "**LuaLaTex** is not installed; *Make Books* needs it to make PDF's"
        case .kepubify:
            return "**Kepubify** is not installed; *Make Books* needs it to make Kobo ePub's"
        }
    }
}
