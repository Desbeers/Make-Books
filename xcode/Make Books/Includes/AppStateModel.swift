//
//  AppStateModel.swift
//  Make Books
//
//  Copyright © 2023 Nick Berendsen
//

import Foundation

// MARK: ObservableObject: AppState

/// State of application
class AppState: ObservableObject {
    /// Show sheet with log or dropper
    @Published var showSheet = false
    /// The active sheet
    @Published var activeSheet: ActiveSheet = .log
    /// The type of sheet we can show
    enum ActiveSheet {
        case log, dropper
    }
}
