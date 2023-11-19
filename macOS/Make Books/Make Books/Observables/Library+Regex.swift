//
//  Library+Regex.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import Foundation
import RegexBuilder

extension Library {

    /// A regex for parsing metadata of a ``Book``
    static let metaDataRegex = Regex {
        Capture {
            OneOrMore {
                CharacterClass(
                    .anyOf(":").inverted
                )
            }
        } transform: {
            Metadata(rawValue: $0.lowercased())
        }
        ":"
        Capture {
            OneOrMore(.any)
        } transform: {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
