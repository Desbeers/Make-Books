//  SharedFunctions.swift
//  Make books
//
//  Copyright © 2021 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - getDocumentsDirectory()

// Returns the users Documents directory.
// Used when no folders are selected by the user.

func getDocumentsDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}

// MARK: - getLastPath(path)

// Gets the full path to the folder
// Returns the last path

func getLastPath(_ path: String) -> String {
    let lastPath = (URL(fileURLWithPath: path).lastPathComponent)
    return lastPath
}

// MARK: - getArgs(path)

// Gets the full book object
// Returns a string with arguments

func getArgs(_ options: MakeOptions, _ pathBooks: String, _ pathExport: String, _ pdfPaper: String, _ pdfFont: String) -> String {
    var makeArgs = "--gui mac "
    makeArgs += "--paper " + pdfPaper + " "
    makeArgs += "--font " + pdfFont + " "
    makeArgs += "--books \"" + pathBooks + "\" "
    makeArgs += "--export \"" + pathExport + "\" "
    for option in options.options where option.isSelected == true {
        makeArgs += " " + option.make + " "
    }
    return (makeArgs)
}

// MARK: applyTheme(scheme)

// Gets selected theme
// Set the window appearance

func applyTheme(_ appTheme: String) {
    switch appTheme {
    case "dark":
        NSApp.appearance = NSAppearance(named: .darkAqua)
    case "light":
        NSApp.appearance = NSAppearance(named: .aqua)
    default:
        NSApp.appearance = nil
    }
}

// MARK: Folder selector

/// Books folder selection
func selectBooksFolder(_ books: Books) {
    let base = UserDefaults.standard.object(forKey: "pathBooks") as? String ?? getDocumentsDirectory()
    let dialog = NSOpenPanel()
    dialog.showsResizeIndicator = true
    dialog.showsHiddenFiles = false
    dialog.canChooseFiles = false
    dialog.canChooseDirectories = true
    dialog.directoryURL = URL(fileURLWithPath: base)
    dialog.message = "Select the folder with your books"
    dialog.prompt = "Select"
    dialog.beginSheetModal(for: NSApp.keyWindow!) { result in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            /// Save the url
            UserDefaults.standard.set(result!.path, forKey: "pathBooks")
            /// Refresh the list of books
            books.bookList = GetBooksList()
            /// Clear the selected book (if any)
            books.bookSelected = nil
        }
    }
}
/// Export folder selection
func selectExportFolder() {
    let base = UserDefaults.standard.object(forKey: "pathExport") as? String ?? getDocumentsDirectory()
    let dialog = NSOpenPanel()
    dialog.showsResizeIndicator = true
    dialog.showsHiddenFiles = false
    dialog.canChooseFiles = false
    dialog.canChooseDirectories = true
    dialog.directoryURL = URL(fileURLWithPath: base)
    dialog.message = "Select the export folder for your books"
    dialog.prompt = "Select"
    dialog.beginSheetModal(for: NSApp.keyWindow!) { result in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            UserDefaults.standard.set(result!.path, forKey: "pathExport")
        }
    }
}

// MARK: getCover(path)

// Gets path to cover
// Returns the cover image

func getCover(cover: String) -> NSImage {
    let url = URL(fileURLWithPath: cover)
    if let imageData = try? Data(contentsOf: url) {
        return NSImage(data: imageData)!
    }
    /// This should not happen
    return NSImage()
}

// MARK: openInFinder(url)

// Open a folder in the Finder

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

// MARK: doesFileExists(url)

// Checks if a file or folder exists
// Returns TRUE or FALSE

func doesFileExists(url: URL) -> Bool {
    if FileManager.default.fileExists(atPath: url.path) {
        return true
    }
    return false
}

// MARK: openInTerminal(url)

// Open a folder in the Terminal

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

// MARK: - FancyBackground()

// Returns a sidebar color

struct FancyBackground: NSViewRepresentable {
  func makeNSView(context: Context) -> NSVisualEffectView {
    return NSVisualEffectView()
  }
  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    // Nothing to do.
  }
}

// MARK: - runInShell()

// Run a shell command

/// https://stackoverflow.com/questions/26971240/how-do-i-run-a-terminal-command-in-a-swift-script-e-g-xcodebuild
func runInShell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)

    return output
}

// MARK: - Roman()

// Convert Int to Roman

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
