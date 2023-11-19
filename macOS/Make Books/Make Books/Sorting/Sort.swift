//
//  Sort.swift
//  Make Books
//
//  Created by Nick Berendsen on 06/08/2023.
//

import Foundation

public struct Sort: Codable, Equatable, Hashable {
    /// Init the sort order
    public init(
        id: String = "ID",
        method: Sort.Method = .title,
        order: Sort.Order = .ascending
    ) {
        self.id = id
        self.method = method
        self.order = order
    }
    /// The ID of the sort
    public var id: String
    /// The method
    public var method: Method
    /// The order
    public var order: Order
}

extension Sort {

    // MARK: List.Sort.buildKeyPathComparator

    /// Build the sorting method and order for a ``Book`` array
    /// - Parameter sortItem: The sorting
    /// - Returns: An array with `KeyPathComparator`
    static func buildKeyPathComparator(sortItem: Sort) -> [KeyPathComparator<Book>] {
        switch sortItem.method {
        case .title:
            return [ KeyPathComparator(\.sortTitle, order: sortItem.order.value) ]
        case .author:
            return [
                KeyPathComparator(\.sortAuthor, order: sortItem.order.value),
                KeyPathComparator(\.date, order: .forward),
                KeyPathComparator(\.sortTitle, order: .forward)
            ]
        case .hasBeenReed:
            return [
                KeyPathComparator(\.hasBeenRead?.comparable, order: sortItem.order.value),
                KeyPathComparator(\.sortAuthor, order: .forward),
                KeyPathComparator(\.sortTitle, order: .forward)
            ]
        case .date:
            return [
                KeyPathComparator(\.date, order: sortItem.order.value),
                KeyPathComparator(\.sortTitle, order: .forward)
            ]
        }
    }
}

// MARK: Return a sorted Array

extension Array where Element == Book {

    /// Sort an Array of KodiItem's
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    func sorted(sortItem: Sort) -> Array {
        let sorting = Sort.buildKeyPathComparator(sortItem: sortItem)
        return self.sorted(using: sorting)
    }
}

// MARK: Sort in place

extension Array where Element == Book {

    /// Sort an Array of KodiItem's
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    mutating func sort(sortItem: Sort) {
        let sorting = Sort.buildKeyPathComparator(sortItem: sortItem)
        self.sort(using: sorting)
    }
}
