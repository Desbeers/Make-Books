//
//  Router.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import Foundation

/// Router for Make Books navigation
enum Router: Hashable {
    /// Books View
    case books
    /// Single book View
    case book(book: Book)
    /// Series View
    case series
    /// Single serie View
    case serie(serie: Serie)
    /// Authors View
    case authors
    /// Single author View
    case author(author: Author)
    /// Collections View
    case collections
    /// Single collection View
    case collection(collection: Collection)
    /// Tags View
    case tags
    /// Single tag View
    case tag(tag: Book)
    /// File dropper View
    case fileDropper
    /// SearchView
    case search

    /// Edit a book
    case edit(book: Book)
    /// Add a book
    case add

    /// Main items
    static var main: [Router] {
        [.books, .authors, .series, .collections, .tags]
    }
    /// Create items
    static var create: [Router] {
        [.add, .fileDropper]
    }
}
