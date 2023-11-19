//
//  Author.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import Foundation

/// The structure of an Author
struct Author: Identifiable, Hashable {
    /// The ID of the Author
    let id = UUID()
    /// The name of the Author
    let name: String
    /// The sort name of the Author
    let sortName: String
    /// The books of the Author
    let books: [Book]
}
