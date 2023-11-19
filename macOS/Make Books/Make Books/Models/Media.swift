//
//  Media.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import Foundation

/// The kind of media to compile
enum Media: String, Codable {
    /// A 'normal' book
    case book
    /// A collectkion of books
    case collection
    /// A book based on a 'tag'
    case tag
    /// Just a PDF from a single file
    case makePDF
    /// Media that `Make Books` can create
    static var create: [Media] {
        [.book, .collection, .tag]
    }
    /// The script to build a book
    var script: String {
        switch self {
        case .book:
            return "terminal/make-book"
        case .collection:
            return "terminal/make-collection"
        case .tag:
            return "terminal/make-tag-book"
        case .makePDF:
            return "terminal/make-pdf"
        }
    }
    /// The configuration file for the media
    var yamlFile: String {
        switch self {
        case .book:
            return "make-book"
        case .collection:
            return "make-collection"
        case .tag:
            return "make-tag-book"
        default:
            return ""
        }
    }
    /// The label for the kind of media
    var label: String {
        switch self {
        case .book:
            return "Book"
        case .collection:
            return "Collection"
        case .tag:
            return "Tag"
        default:
            return "Unknown"
        }
    }
}
