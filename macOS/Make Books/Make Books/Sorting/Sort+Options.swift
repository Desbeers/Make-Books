//
//  Sort+Options.swift
//  Make Books
//
//  Created by Nick Berendsen on 06/08/2023.
//

import Foundation

extension Sort {

    enum Options: String, CaseIterable {
        case title
        case author
        case date
        case new
        case read

        var sorting: Sort {
            switch self {

            case .title:
                return Sort(method: .title, order: .ascending)
            case .author:
                return Sort(method: .author, order: .ascending)
            case .date:
                return Sort(method: .date, order: .ascending)
            case .new:
                return Sort(method: .hasBeenReed, order: .ascending)
            case .read:
                return Sort(method: .hasBeenReed, order: .descending)
            }
        }

        var label: String {
            switch self {

            case .title:
                return "Title"
            case .author:
                return "Author"
            case .date:
                return "Date"
            case .new:
                return "New"
            case .read:
                return "Read"
            }
        }
    }
}
