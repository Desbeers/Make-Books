//
//  Utilities.swift
//  Make Books
//
//  © 2023 Nick Berendsen
//

import Foundation

enum Utility: String, CaseIterable {
    case pandoc = "which pandoc"
    case font = "fc-list --format=\"%{file[0]}\" GreatVibes"
    case lualatex = "which lualatex"
    case kepubify = "which kepubify"
}

extension Utility {
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
