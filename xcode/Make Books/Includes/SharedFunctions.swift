//  SharedFunctions.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

// MARK: Folder selector

/// Books folder selection
/// - Parameter books: The books model
@MainActor func selectBooksFolder(_ books: Books) {
    FolderBookmark.select(
        prompt: "Select",
        message: "Select the folder with your books",
        bookmark: "BooksPath"
    ) {
        Task {
            /// Refresh the list of books
            await books.getFiles()
        }
    }
}

/// Export folder selection
/// - Parameter books: The books model
@MainActor func selectExportFolder(_ books: Books) {
    FolderBookmark.select(
        prompt: "Select",
        message: "Select the export folder for your books",
        bookmark: "ExportPath"
    ) {
        // No action needed after selection
    }
}

// MARK: getCover

/// Get the cover of a book
/// - Parameter cover: The cover URL
/// - Returns: An NSImage with the cover
func getCover(cover: URL) -> NSImage {
    if let imageData = try? Data(contentsOf: cover) {
        return NSImage(data: imageData)!
    }
    /// This should not happen
    return NSImage()
}

// MARK: openInFinder

/// Open a folder in the Finder
/// - Parameter url: The URL of the folder
func openInFinder(url: URL?) {
    guard let url = url else {
        print("Not a valid URL")
        return
    }
    /// This opens the actual folder:
    /// NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
    /// This selects the folder; I like that better:
    NSWorkspace.shared.activateFileViewerSelecting([url])
}

// MARK: openInTerminal

/// Open a folder in the Terminal
/// - Parameter url: The URL of the folder
func openInTerminal(url: URL?) {
    guard let terminal = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Terminal") else {
        return
    }
    guard let url = url else {
        print("Not a valid URL")
        return
    }
    let configuration = NSWorkspace.OpenConfiguration()
    NSWorkspace.shared.open([url], withApplicationAt: terminal, configuration: configuration)
}

// MARK: doesFileExists

/// Check if a file or folder exists
/// - Parameter url: The URL to the item
/// - Returns: True or false
func doesFileExists(url: URL) -> Bool {
    if FileManager.default.fileExists(atPath: url.path) {
        return true
    }
    return false
}

// MARK: romanNumber

/// Convert a numer to Roman
/// - Parameter number: The number
/// - Returns: The number in roman style
func romanNumber(number: String) -> String {
    let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
    let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    var romanValue = ""
    var startingValue = Int(number) ?? 1
    for (index, romanChar) in romanValues.enumerated() {
        let arabicValue = arabicValues[index]
        let div = startingValue / arabicValue
        if div > 0 {
            for _ in 0..<div {
                romanValue += romanChar
            }
            startingValue -= arabicValue * div
        }
    }
    return romanValue
}
