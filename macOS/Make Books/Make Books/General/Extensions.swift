//
//  Extensions.swift
//  Make Books
//
//  Created by Nick Berendsen on 09/08/2023.
//

import SwiftUI

// MARK: String extensions

extension String {

    /// Remove prefixes from a String
    /// - Parameter prefixes: An aray of prefixes
    /// - Returns: A String with al optonal prefixes removed
    func removePrefixes(_ prefixes: [String]) -> String {
        let pattern = "^(\(prefixes.map { "\\Q" + $0 + "\\E" }.joined(separator: "|")))\\s?"
        guard let range = self.range(of: pattern, options: [.regularExpression, .caseInsensitive]) else {
            return self
        }
        return String(self[range.upperBound...])
    }
}

// MARK: Bool extensions

public extension Bool {

    /// A way to compare `Bool`s
    /// - Note: `false` is "less than" `true`
    /// - Note: Used to sort arrays by Bool
    enum Comparable: CaseIterable, Swift.Comparable {
        case `false`, `true`
    }

    /// Make a `Bool` `Comparable`, with `false` being "less than" `true`.
    var comparable: Comparable { .init(booleanLiteral: self) }
}

extension Bool.Comparable: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = value ? .true : .false
    }
}

// MARK: Binding extensions

/// Rebind a Binding<T?> as Binding<T> using a default value
/// https://stackoverflow.com/questions/57021722/swiftui-optional-textfield
/// - Note: - Used in ``EditBookView``
func bind<T>(_ boundOptional: Binding<T?>, `default`: T) -> Binding<T> {
    Binding(
        get: { boundOptional.wrappedValue ?? `default` },
        set: { boundOptional.wrappedValue = $0 }
    )
}
