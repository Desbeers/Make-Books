//
//  ScriptsModel.swift
//  Make Books
//
//  Copyright © 2023 Nick Berendsen
//

import Foundation

// MARK: ObservableObject: Scripts

/// State of scripts and application
class Scripts: ObservableObject {
    /// State of zsh scripts
    @Published var isRunning = false
    /// Log from zsh scripts
    @Published var log = [Log]()
}
