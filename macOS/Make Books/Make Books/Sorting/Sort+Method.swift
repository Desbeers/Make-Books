//
//  Sort+Method.swift
//  Make Books
//
//  Created by Nick Berendsen on 06/08/2023.
//

import Foundation

extension Sort {

    // MARK: List.Sort.Method

    /// The sort method (SwiftlyKodi Type)
    public enum Method: String, Codable, CaseIterable {
        /// Order by title
        case title = "title"
        /// Order by author
        case author = "author"
        /// Order by read state
        case hasBeenReed = "has-been-read"
        /// Order by date
        case date = "date"
        /// The label of the method (not complete)
        public var displayLabel: String {
            switch self {

            case .title:
                return "Sort by title"
            case .author:
                return "Sort by author"
            case .hasBeenReed:
                return "Sort by status"
            case .date:
                return "Sort by date"
            }
        }
    }
}
