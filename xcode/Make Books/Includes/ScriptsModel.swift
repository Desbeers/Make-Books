//
//  ScriptsModel.swift
//  Make Books
//
//  Copyright © 2023 Nick Berendsen
//

import SwiftUI

// MARK: ObservableObject: Scripts

/// The class with the state of scripts
class Scripts: ObservableObject {
    /// State of zsh scripts
    @Published var isRunning = false
    /// Log from zsh scripts
    @Published var log = [LogItem]()
}

extension Scripts {

    /// The structure of a log item
    struct LogItem: Identifiable, Equatable {
        /// The ID of the log
        let id = UUID()
        /// The type of the log
        let type: LogType
        /// The message of the log
        let message: String
        /// The symbol used in the list of LogView
        var symbol: String {
            switch type {
            case .action:
                return "book"
            case .notice:
                return "info.circle.fill"
            case .error:
                return "xmark.octagon.fill"
            case .targetStart:
                return "gear"
            case .targetEnd:
                return "checkmark"
            case .targetClean:
                return "scissors"
            case .logStart:
                return "hourglass.tophalf.fill"
            case .logEnd:
                return "hourglass.bottomhalf.fill"
            default:
                return "questionmark"
            }
        }
        /// The color of the symbols used in the list of LogView
        var color: Color {
            switch type {
            case .error:
                return .red
            case .targetStart:
                return .orange
            case .targetEnd:
                return .green
            case .targetClean:
                return .blue
            default:
                return .primary
            }
        }
        /// Log types
        enum LogType: String {
            case action
            case notice
            case error
            case targetStart
            case targetEnd
            case targetClean
            case logStart
            case logEnd
            case unknown
        }
    }
}
