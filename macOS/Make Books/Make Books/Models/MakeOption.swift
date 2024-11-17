//
//  MakeOption.swift
//  Make Books
//
//  Created by Nick Berendsen on 21/07/2023.
//

import Foundation

/// The structure of a Make option
struct MakeOption: Identifiable, Equatable {
    /// The ID of the option
    var id = UUID()
    /// The `make` target
    var make: String
    /// The utilities needed for the target
    var utilities: [Utility]
    /// The label of the target
    var label: String
    /// Description of the target
    var description: String
    /// Bool if the target is selected
    var isSelected: Bool
}
