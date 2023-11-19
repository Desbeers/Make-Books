//
//  Collection.swift
//  Make Books
//
//  Created by Nick Berendsen on 18/07/2023.
//

import Foundation

/// The structure of a Book Collection
struct Collection: Identifiable, Hashable {
    /// The ID of the ``Collection``
    var id = UUID()
    /// The ``Book`` that contains the ``Collection``
    var book: Book
    /// Array of ``Book`` that are part of the ``Collection``
    var books: [Book]
}
