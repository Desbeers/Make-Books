//
//  MakeStete.swift
//  Make Books
//
//  Created by Nick Berendsen on 22/07/2023.
//

import SwiftUI

/// The class with the Make state
@Observable
final class MakeState {
    /// List of `make` options
    var options: [MakeOption] = UserSetting.getMakeOptions
    /// State of zsh scripts
    var scriptIsRunning = false
    /// Log from zsh scripts
    var log = [Log]()
    /// The utilities to create a book
    var utilities: [Utility] = []
    /// List of missing utilities
    var notAvailable: [String] = []
}

extension MakeState {

    /// The arguments for Make
    /// - Returns: A String with all arguments
    var arguments: String {
        var makeArgs = "--gui mac "
        makeArgs += "--paper " + UserSetting.getPaperSetting + " "
        makeArgs += "--font " + UserSetting.getFontSetting + " "
        makeArgs += "--books \"" + UserSetting.getBooksFolder + "\" "
        makeArgs += "--export \"" + UserSetting.getExportFolder + "\" "
        for option in options where option.isSelected == true {
            makeArgs += " " + option.make + " "
        }
        return (makeArgs)
    }

    /// Make all books
    /// - Parameter books: An array of ``Book``
    func makeBooks(books: [Book]) {
        /// Empty the Log
        log = []
        for book in books {
            log.append(.init(type: .notice, message: "Compiling '\(book.title)'"))
            makeBook(book: book)
        }
    }

    /// Make a book
    /// - Parameter book: The ``Book``
    func makeBook(book: Book) {
        guard
            let script = Bundle.main.url(forResource: book.media.script, withExtension: nil)
        else {
            return
        }
        let arguments = [
            "cd '" +
            book.sourceURL.path(percentEncoded: false) +
            "' && '" + script.path + "' " +
            arguments
        ]
        runShellScript(arguments: arguments)
    }

    /// Run a command in the shell
    /// - Parameter arguments: The arguments
    func runShellScript(arguments: [String]) {
        Task { @MainActor in
            /// Start with a fresh log
            log = [.init(type: .logStart, message: "Making your books")]
            scriptIsRunning = true
            for await output in Terminal.runInShell(arguments: arguments) {
                switch output {
                case let .standardOutput(outputLine):
                    parseLogLine(line: outputLine)
                case let .standardError(errorLine):
                    parseLogLine(line: errorLine)
                }
            }
            scriptIsRunning = false
            log.append(.init(type: .logEnd, message: "Done!"))
        }
    }

    /// Parse a log line
    /// - Parameter line: The line from the log
    func parseLogLine(line: String) {
        let message = line.trimmingCharacters(in: .whitespacesAndNewlines)
        let lineArr = message.components(separatedBy: ":")
        let type = Log.LogType(rawValue: lineArr[0]) ?? .unknown
        log.append(.init(type: type, message: type == .unknown ? message : lineArr[1]))
    }
}

extension MakeState {

    @MainActor func checkUtilities() async {
        /// Check font
        let font = NSFontManager.shared.availableFontFamilies.filter { $0 == Utility.font.rawValue }
        if font.isEmpty {
            notAvailable.append(Utility.font.notAvailable)
        } else {
            utilities.append(Utility.font)
        }
        /// Check terminal utilities
        for utility in Utility.terminal {
            if await Terminal.which(utility.rawValue) != nil {
                utilities.append(utility)
            } else {
                notAvailable.append(utility.notAvailable)
            }
        }
    }

    func available( _ option: MakeOption) -> Bool {
        option.utilities.allSatisfy(utilities.contains)
    }
}
