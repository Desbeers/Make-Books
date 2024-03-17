//  SharedFunctions.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI
import SwiftlyFolderUtilities

// MARK: Folder selector

/// Books folder selection
/// - Parameter books: The books model
func selectBooksFolder(_ books: Books) -> some View {
    FolderBookmark.SelectFolderButton(
        bookmark: "BooksPath",
        message: "Select the folder with your books",
        confirmationLabel: "Select",
        buttonLabel: "Books",
        buttonSystemImage: "square.and.arrow.up.on.square"
    ) {
        Task { @MainActor in
            await books.getFiles()
        }
    }
}

func selectExportFolder(_ books: Books) -> some View {
    FolderBookmark.SelectFolderButton(
        bookmark: "ExportPath",
        message: "Select the export folder for your books",
        confirmationLabel: "Select",
        buttonLabel: "Export",
        buttonSystemImage: "square.and.arrow.down.on.square"
    ) {
        // No action needed
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
func romanNumber(number: Int) -> String {
    let romanValues = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
    let arabicValues = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    var romanValue = ""
    var startingValue = number
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
