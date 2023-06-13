//  MakeView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

/// The action buttons
struct MakeView: View {
    /// The state of the application
    @EnvironmentObject var appState: AppState
    /// Get the list of books
    @EnvironmentObject var books: Books
    /// Get the Make options
    let makeOptions: MakeOptions
    /// Observe script related stuff
    @EnvironmentObject var scripts: Scripts
    /// The body of the View
    var body: some View {
        VStack {
            if let book = books.selectedBook {
                Text("\"\(book.title)\" is selected")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack {
                /// Make selected book
                Button {
                    if let book = books.selectedBook,
                       let script = Bundle.main.url(forResource: book.type.rawValue, withExtension: nil) {
                        let arguments = ["cd '" +
                                         book.folderURL.path(percentEncoded: false) +
                                         "' && '" + script.path + "' " +
                                         makeOptions.arguments
                        ]
                        runShellScript(arguments: arguments)
                    }
                } label: {
                    Text("Selected book")
                }
                .disabled(books.selectedBook == nil)
                /// Make all books
                Button {
                    if let script = Bundle.main.url(forResource: BookType.allBooks.rawValue, withExtension: nil) {
                        let arguments = ["'\(script.path)' " + makeOptions.arguments ]
                        runShellScript(arguments: arguments)
                    }
                } label: {
                    Text("All books")
                }
                /// Make all collections
                Button {
                    if let script = Bundle.main.url(forResource: BookType.allCollections.rawValue, withExtension: nil) {
                        let arguments = ["'\(script.path)' " + makeOptions.arguments ]
                        runShellScript(arguments: arguments)
                    }
                } label: {
                    Text("Collections")
                }
                /// Make all tags
                Button {
                    if let script = Bundle.main.url(forResource: BookType.allTags.rawValue, withExtension: nil) {
                        let arguments = ["'\(script.path)' " +  makeOptions.arguments ]
                        runShellScript(arguments: arguments)
                    }
                } label: {
                    Text("Tags")
                }
            }
            .padding([.leading, .bottom, .trailing])
        }
        .frame(height: 40, alignment: .bottom)
        .disabled(appState.showSheet)
    }

    func runShellScript(arguments: [String]) {
        Task {
            /// Start with a fresh log
            scripts.log = [Log(type: .logStart, message: "Making your books")]
            appState.activeSheet = .log
            appState.showSheet = true
            scripts.isRunning = true
            for await output in shell(arguments: arguments) {
                switch output {
                case let .standardOutput(outputLine):
                    parseLogLine(line: outputLine)
                case let .standardError(errorLine):
                    parseLogLine(line: errorLine)
                }
            }
            scripts.isRunning = false
            scripts.log.append(Log(type: .logEnd, message: "Done!"))
        }
    }

    func parseLogLine(line: String) {
        var type: Log.LogType = .unknown
        var message = line.trimmingCharacters(in: .whitespacesAndNewlines)
        let lineArr = message.components(separatedBy: ":")
        switch lineArr[0] {
        case "action":
            type = .action
            message = lineArr[1]
        case "notice":
            type = .notice
            message = lineArr[1]
        case "targetStart":
            type = .targetStart
            message = lineArr[1]
        case "targetEnd":
            type = .targetEnd
            message = lineArr[1]
        case "targetClean":
            type = .targetClean
            message = lineArr[1]
        default:
            type = .unknown
        }
        scripts.log.append(Log(type: type, message: message))
    }
}
