//
//  EditBookView+Status.swift
//  Make Books
//
//  Created by Nick Berendsen on 04/09/2023.
//

import SwiftUI

/// The status of the book
public enum Status {
    /// A new book
    case new
    ///  An existing book
    case existing
}

extension Status {

    enum BookError: LocalizedError {
        case bookExtists
        case overwriteFile
        case unsavedData
        case unknownError

        public var description: String {
            switch self {
            case .bookExtists:
                "A book with this title already exists in this folder"
            case .overwriteFile:
                "Are you sure you want to overwrite the book information?"
            case .unsavedData:
                "Are you sure you want to close?"
            case .unknownError:
                "Unknown error"
            }
        }

        public var errorDescription: String? {
            return description
        }

        public var failureReason: String? {
            switch self {
            case .bookExtists:
                "Existing Book"
            case .overwriteFile:
                "Existing File"
            case .unsavedData:
                "Unsaved Data"
            case .unknownError:
                "Unknown error"
            }
        }

        var recoverySuggestion: String? {
            switch self {
            case .bookExtists:
                "Please select another folder."
            case .overwriteFile:
                "This can not be undone."
            case .unsavedData:
                "Changes to the book will be lost."
            default:
                nil
            }
        }

        var helpAnchor: String? {
            switch self {
            case .bookExtists:
                "I'm sorry"
            case .overwriteFile:
                "Overwrite"
            case .unsavedData:
                "I don't care"
            default:
                nil
            }
        }
    }
}
