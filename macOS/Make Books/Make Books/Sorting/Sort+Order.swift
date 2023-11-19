//
//  Sort+Order.swift
//  Make Books
//
//  Created by Nick Berendsen on 06/08/2023.
//

import Foundation

extension Sort {

    // MARK: List.Sort.Order

    /// The sort order (SwiftlyKodi Type)
    public enum Order: String, Codable, CaseIterable {
        /// Order ascending
        case ascending
        /// Order descending
        case descending
        /// The `SortOrder` value
        public var value: SortOrder {
            switch self {
            case .ascending:
                return .forward
            case .descending:
                return .reverse
            }
        }
        /// Label for the sort order
        /// - Parameter method: The sort method
        /// - Returns: A String with the appropriate label
        public func displayLabel(method: Sort.Method) -> String {
            switch self {
            case .ascending:
                switch method {
                case .title, .author:
                    return "A - Z"
                case .hasBeenReed:
                    return "Read first"
                case .date:
                    return "Oldest first"
                }
            case .descending:
                switch method {
                case .title, .author:
                    return "Z - A"
                case .hasBeenReed:
                    return "New first"
                case .date:
                    return "Newest first"
                }
            }
        }
    }
}
