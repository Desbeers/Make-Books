//
//  MakeBooksDocument.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI
import UniformTypeIdentifiers

/// The MakeBooksDocument for Make Books
struct MakeBooksDocument: FileDocument {
    /// The content of a Make Book document
    var content: String
    /// Init the content
    init(content: String = "") {
        self.content = content
    }
    /// The `UTType` for a Make Book document
    static var readableContentTypes: [UTType] { [.makeBook] }
    /// Init the configuration
    init(configuration: ReadConfiguration) throws {
        guard
            let data = configuration.file.regularFileContents,
            let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        content = string
    }

    /// Write the document
    /// - Parameter configuration: The document configuration
    /// - Returns: A file in the file system
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        // swiftlint:disable:next force_unwrapping
        let data = content.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}

extension UTType {

    /// The `UTType` for a Make Book document
    static var makeBook: UTType {
        UTType(exportedAs: "nl.desbeers.makebooks.makebook")
    }
    /// The `UTType` for a Markdown document
    static var markdown: UTType {
        UTType(importedAs: "net.daringfireball.markdown")
    }
}
