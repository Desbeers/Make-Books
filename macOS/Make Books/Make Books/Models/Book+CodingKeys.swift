//
//  Book+CodingKeys.swift
//  Make Books
//
//  Created by Nick Berendsen on 24/07/2023.
//

import Foundation

/// Shortcut to the Coding Keys of the ``Book``
typealias Metadata = Book.CodingKeys

extension Book {

    /// The `Coding Keys` for a ``Book``
    ///
    /// Only variables from the `Book` struct that have a coding key will be part of the generated yaml file
    enum CodingKeys: String, CodingKey {
        /// The title of the ``Book``
        case title
        /// The Author of the ``Book``
        case author
        /// Description of the ``Book``
        case description
        /// The date of the ``Book``
        case date
        /// The rights of the ``Book``
        case rights
        /// The publisher of the ``Book``
        case publisher
        /// The language of the ``Book``
        case language = "lang"
        /// The subject of the ``Book``
        case subject
        /// The optional Serie name of the ``Book``
        case belongsToSerie = "belongs-to-collection"
        /// The Position of the optional Serie of the ``Book``
        case seriePosition = "group-position"
        /// The ``Media`` kind of the ``Book``
        case media
        /// The Tag of the ``Book``if `media = .tag`
        case tag
        /// The name of the ``Book`` Collection if `media = .collection`
        case collection
        /// The optional Collection the ``Book`` belongs to
        case addToCollection = "add-to-collection"
        /// Bool if the ``Book`` has been read
        case hasBeenRead = "has-been-read"
        /// The ``ChapterStyle`` of the ``Book``
        case chapterStyle = "chapter-style"
        /// The revision of the ``Book``
        case revision
    }
}

extension Book.CodingKeys {

    /// The label of a metadata item
    var label: String {
        switch self {
        case .title:
            return "Title"
        case .author:
            return "Author"
        case .description:
            return "Description"
        case .date:
            return "Date"
        case .rights:
            return "Rights"
        case .publisher:
            return "Publisher"
        case .language:
            return "Language"
        case .belongsToSerie:
            return "Part of serie"
        case .seriePosition:
            return "Serie number"
        case .media:
            return "Type of book"
        case .hasBeenRead:
            return "Has been read"
        case .chapterStyle:
            return "Chapter style"
        case .revision:
            return "Revision"
        case .subject:
            return "Subject"
        case .collection:
            return "Collection"
        case .tag:
            return "Tag"

        default:
            return rawValue
        }
    }

    /// Label when the metadata is empty
    var empty: String {
        switch self {
        case .title:
            return "Title (required)"
        case .author:
            return "Author (required)"
        case .description:
            return "No description available"
        case .date:
            return "Unknown date"
        case .rights:
            return "No rights available"
        case .publisher:
            return "Unknown publisher"
        case .language:
            return "Unknown language"
        case .belongsToSerie:
            return "Not a part of a serie"
        case .revision:
            return "Unknown revision"
        case .subject:
            return "Unknown subject"
        case .collection:
            return "Name of the collection (required)"
        case .tag:
            return "The tag for the book (required)"
        default:
            return rawValue
        }
    }

    var description: String {
        switch self {
        case .belongsToSerie:
            return("The serie this book belongs to")
        case .hasBeenRead:
            return ("Mark this book as read")
        default:
            return ""
        }
    }
}
