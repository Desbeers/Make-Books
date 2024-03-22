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
            "Title"
        case .author:
            "Author"
        case .description:
            "Description"
        case .date:
            "Date"
        case .rights:
            "Rights"
        case .publisher:
            "Publisher"
        case .language:
            "Language"
        case .belongsToSerie:
            "Part of serie"
        case .seriePosition:
            "Serie number"
        case .media:
            "Type of book"
        case .hasBeenRead:
            "Has been read"
        case .chapterStyle:
            "Chapter style"
        case .revision:
            "Revision"
        case .subject:
            "Subject"
        case .collection:
            "Collection"
        case .tag:
            "Tag"

        default:
            rawValue
        }
    }

    /// Label when the metadata is empty
    var empty: String {
        switch self {
        case .title:
            "Title (required)"
        case .author:
            "Author (required)"
        case .description:
            "No description available"
        case .date:
            "Unknown date"
        case .rights:
            "Unknown  rights"
        case .publisher:
            "Unknown publisher"
        case .language:
            "Unknown language"
        case .belongsToSerie:
            "Not a part of a serie"
        case .revision:
            "Unknown revision"
        case .subject:
            "Unknown subject"
        case .collection:
            "Name of the collection (required)"
        case .tag:
            "The tag for the book (required)"
        default:
            rawValue
        }
    }

    var description: String {
        switch self {
        case .belongsToSerie:
            "The serie this book belongs to"
        case .hasBeenRead:
            "Mark this book as read"
        default:
            ""
        }
    }
}
