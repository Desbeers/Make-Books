//
//  LogModel.swift
//  Make Books
//
//  Copyright © 2023 Nick Berendsen
//

import SwiftUI

// MARK: struct: Log

/// The logger for the scripts.
struct Log: Identifiable, Equatable {
    let id = UUID()
    let type: LogType
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
