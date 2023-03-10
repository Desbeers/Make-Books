//
//  Shell.swift
//  Make Books
//
//  © 2023 Nick Berendsen. All rights reserved.
//

import Foundation

/// Run a script in the shell and return its output
/// - Parameter arguments: The arguments to pass to the shell
/// - Returns: The output from the shell
func shell(arguments: [String]) async -> TerminalOutput {
    /// The normal output
    var allOutput: [String] = []
    /// The error output
    var allErrors: [String] = []
    /// Await the results
    for await streamedOutput in shell(arguments: arguments) {
        switch streamedOutput {
        case let .standardOutput(output):
            allOutput.append(output)
        case let .standardError(error):
            allErrors.append(error)
        }
    }
    /// Return the output
    return TerminalOutput(
        standardOutput: allOutput.joined(),
        standardError: allErrors.joined()
    )
}

/// Run a script in the shell and return its output
/// - Parameter arguments: The arguments to pass to the shell
/// - Returns: The output from the shell as a stream
func shell(arguments: [String]) -> AsyncStream<StreamedTerminalOutput> {
    /// Create the task
    let task = Process()
    task.launchPath = "/bin/zsh"
    task.arguments = ["--login", "-c"] + arguments
    /// Standard output
    let pipe = Pipe()
    task.standardOutput = pipe
    /// Error output
    let errorPipe = Pipe()
    task.standardError = errorPipe
    /// Try to run the task
    do {
        try task.run()
    } catch {
        print(error.localizedDescription)
    }
    /// Return the stream
    return AsyncStream { continuation in
        pipe.fileHandleForReading.readabilityHandler = { handler in
            guard let standardOutput = String(data: handler.availableData, encoding: .utf8) else {
                return
            }
            guard !standardOutput.isEmpty else {
                return
            }
            continuation.yield(.standardOutput(standardOutput))
        }
        errorPipe.fileHandleForReading.readabilityHandler = { handler in
            guard let errorOutput = String(data: handler.availableData, encoding: .utf8) else {
                return
            }
            guard !errorOutput.isEmpty else {
                return
            }
            continuation.yield(.standardError(errorOutput))
        }
        /// Finish the stream
        task.terminationHandler = { _ in
            continuation.finish()
        }
    }
}

/// The complete output from the shell
struct TerminalOutput {
    var standardOutput: String
    var standardError: String
}

/// The stream output from the shell
enum StreamedTerminalOutput {
    case standardOutput(String)
    case standardError(String)
}
