//
//  Log.swift
//  Make Books
//
//  Created by Nick Berendsen on 22/07/2023.
//

import SwiftUI

/// The structure of a Log item
struct Log: Identifiable, Equatable {
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
        /// An action
        case action
        /// A notice
        case notice
        /// An error
        case error
        /// Start of making a target
        case targetStart
        /// End of making a target
        case targetEnd
        /// Start cleaning a target
        case targetClean
        /// Start of logging
        case logStart
        /// End of logging
        case logEnd
        /// An unknown log type
        case unknown
    }
}
