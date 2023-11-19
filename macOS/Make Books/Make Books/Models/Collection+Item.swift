//
//  Collection+Item.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import Foundation

extension Collection {

    /// The structure of an Item in a Book Collection
    struct Item: Identifiable, Hashable, Codable {
        /// The ID of the item
        var id: String {
            "\(name)\(collectionPosition)"
        }
        /// Name of the item
        var name: String = ""
        /// Position of the item in the collection
        var collectionPosition: Int = 1
        /// Bool if selected
        /// - Note: For the 'collections edit form' only
        var isSelected: Bool = true
    }
}
