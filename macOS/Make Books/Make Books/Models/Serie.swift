//
//  Serie.swift
//  Make Books
//
//  Created by Nick Berendsen on 18/07/2023.
//

import Foundation

/// The structure of a Book Serie
struct Serie: Identifiable, Hashable {
    /// The ID of the ``Serie``
    var id = UUID()
    /// The title of the ``Serie``
    var title: String
    /// The authors of the ``Serie``
    var authors: [String]
    /// The array of ``Book`` that are part of the ``Serie``
    var books: [Book]
}
