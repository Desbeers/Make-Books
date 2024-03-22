//
//  Book.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI
import SwiftlyFolderUtilities

extension KeyedEncodingContainer {
    mutating func encode(_ value: String, forKey key: K) throws {
        guard !value.isEmpty else { return }
        try encodeIfPresent(value, forKey: key)
    }
    mutating func encode(_ value: Int, forKey key: K) throws {
        guard !(value == 0) else { return }
        try encodeIfPresent(value, forKey: key)
    }
    mutating func encode(_ value: Bool, forKey key: K) throws {
        guard !(value == false) else { return }
        try encodeIfPresent(value, forKey: key)
    }
    mutating func encode(_ value: Book.ChapterStyle, forKey key: K) throws {
        guard !(value == .thatcher) else { return }
        try encodeIfPresent(value, forKey: key)
    }
}

/// The structure of a Book
struct Book: Identifiable, Hashable, Codable {
    /// The title of the ``Book``
    var title: String = ""
    /// The Author of the ``Book``
    var author: String = ""
    /// Description of the ``Book``
    var description: String = ""
    /// The date of the ``Book``
    var date: String = ""
    /// The rights of the ``Book``
    var rights: String = ""
    /// The publisher of the ``Book``
    var publisher: String = ""
    /// The language of the ``Book``
    var language: String = ""
    /// The subject of the ``Book``
    var subject: String = ""
    /// The optional Serie name of the ``Book``
    var belongsToSerie: String = ""
    /// The Position of the optional Serie of the ``Book``
    var seriePosition: Int = 0

    // MARK: Custom (Not used by Pandoc)

    /// The ID of the ``Book``
    var id: UUID = UUID()

    /// The source URL of the ``Book``
    var sourceURL: URL = URL(fileURLWithPath: "")

    /// The file URL of the ``Book`` containing the YAML info
    var yalmURL: URL?


    /// The status of the ``Book``
    var status: Status = .new

    /// Bool if the ``Book`` has been read
    var hasBeenRead: Bool = false
    /// The ``ChapterStyle`` of the ``Book``
    var chapterStyle: ChapterStyle = .thatcher
    /// The cover URL of the ``Book``
    var coverURL: URL?
    /// The ``Media`` kind of the ``Book``
    var media: Media = .book
    /// The Tag of the ``Book``if `media = .tag`
    var tag: String = ""
    /// The name of the ``Book`` Collection if `media = .collection`
    var collection: String = ""

    /// The optional Collections the ``Book`` belongs to
    /// - Note: For the 'collections edit form' only
    var collectionItems: [Collection.Item] = []

    /// Exported version of `collectionItem` struct
    var addToCollection: String?
    /// The revision of the ``Book``
    var revision: String = ""


    // MARK: Calculated Variables

    /// The sort title of the ``Book``
    var sortTitle: String {
        title.removePrefixes(["De", "Het", "Een"])
    }

    /// The sort Author of the ``Book``
    var sortAuthor: String {
        if let index = author.lastIndex(of: " ") {
            return String(author[index...]).trimmingCharacters(in: .whitespaces)
        }
        return author
    }

    /// The assets URL of the ``Book``
    var assetsURL: URL {
        sourceURL.appendingPathComponent("assets")
    }

    /// The `.makebook` URL of the ``Book``
    var makebookURL: URL {
        sourceURL.appendingPathComponent(title, conformingTo: .makeBook)
    }

    /// The export folder URL of the ``Book``
    var exportFolderURL: URL {
        /// Base export folder
        var export = FolderBookmark.getLastSelectedURL(bookmark: UserSetting.exportFolder.rawValue)
        /// Append author and title
        export.append(path: author)
        export.append(path: title)
        /// Return result
        return export
    }
    /// Optional URL for the PDF preview of the ``Book``
    var pdfPreviewURL: URL? {
        let url = exportFolderURL.appendingPathComponent(title, conformingTo: .pdf)
        /// Only return the URL when the file exist, else `nil`
        return FolderUtil.doesUrlExist(url: url)
    }
    /// The calculated Search string of the ``Book``
    var search: String {
        "\(title) \(author)"
    }
    /// The serie label of the ``Book``
    var serie: String {
        if !belongsToSerie.isEmpty {
            return "\(belongsToSerie), part \(seriePosition)"
        }
        return ""
    }
    /// The YAML export of the ``Book``
    var yamlEport: String? {
        var book = self
        /// Convert the `collectionItem array into a string`
        if !collectionItems.isEmpty {
            var items: [String] = []
            for item in collectionItems {
                items.append("\(item.name)=\(item.collectionPosition)")
            }
            book.addToCollection = items.joined(separator: ";")
        }
        /// Set the serie position if needed
        if !book.belongsToSerie.isEmpty, book.seriePosition == 0 {
            book.seriePosition = 1
        }
        /// Compose the YAML data
        do {
            var result: [String] = []
            let data = try JSONEncoder().encode(book)

            if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                for(key, value) in jsonResult {
                    result.append("\(key): \(value)")
                }
            }
            return result.sorted().joined(separator: "\n")
        } catch {
            return nil
        }
    }
}
