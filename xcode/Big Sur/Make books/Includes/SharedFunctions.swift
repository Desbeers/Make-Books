//  SharedFunctions.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Fuctions

// GetDocumentsDirectory()
// ----------
// Returns the users Documents directory.
// Used when no folders are selected by the user.

func GetDocumentsDirectory() -> String {
    return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
}

// GetLastPath(path)
// -----------------
// Gets the full path to the folder
// Returns the last path

func GetLastPath(_ path: String) -> String {
    let lastPath = (URL(fileURLWithPath: path).lastPathComponent)
    return lastPath
}

// GetArgs(path)
// -------------------
// Gets the full book object
// Returns a string with arguments

func GetArgs(_ books: Books, _ pathBooks: String, _ pathExport: String, _ pdfPaper: String, _ pdfFont: String) -> String {
    var makeArgs = ""
    makeArgs += "--paper " + pdfPaper + " "
    makeArgs += "--font " + pdfFont + " "
    makeArgs += "--books \"" + pathBooks + "\" "
    makeArgs += "--export \"" + pathExport + "\" "
    for option in books.optionsMake {
        if option.isSelected == true {
            makeArgs += " " + option.make + " "
        }
    }
    return (makeArgs)
}

// ApplyTheme(scheme)
// -------------------
// Gets selected theme
// Set the window appearance

func ApplyTheme(_ appTheme: String) {
    switch appTheme {
        case "dark":
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case "light":
            NSApp.appearance = NSAppearance(named: .aqua)
        default:
            NSApp.appearance = nil
    }
}

// Folder selector
// ---------------

/// Books folder selection
func SelectBooksFolder(_ books: Books) {
    let base = UserDefaults.standard.object(forKey: "pathBooks") as? String ?? GetDocumentsDirectory()
    let dialog = NSOpenPanel();
    dialog.showsResizeIndicator = true;
    dialog.showsHiddenFiles = false;
    dialog.canChooseFiles = false;
    dialog.canChooseDirectories = true;
    dialog.directoryURL = URL(fileURLWithPath: base)
    dialog.message = "Select the folder with your books"
    dialog.prompt = "Select"
    dialog.beginSheetModal(for: NSApp.keyWindow!) { (result) in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            /// Save the url
            UserDefaults.standard.set(result!.path, forKey: "pathBooks")
            /// Refresh the list of songs
            books.bookList = GetBooksList()
            /// Clear the selected book (if any)
            books.bookSelected = nil
        }
    }
}
/// Export folder selection
func SelectExportFolder() {
    let base = UserDefaults.standard.object(forKey: "pathExport") as? String ?? GetDocumentsDirectory()
    let dialog = NSOpenPanel();
    dialog.showsResizeIndicator = true;
    dialog.showsHiddenFiles  = false;
    dialog.canChooseFiles = false;
    dialog.canChooseDirectories = true;
    dialog.directoryURL = URL(fileURLWithPath: base)
    dialog.message = "Select the export folder for your books"
    dialog.prompt = "Select"
    dialog.beginSheetModal(for: NSApp.keyWindow!) { (result) in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            UserDefaults.standard.set(result!.path, forKey: "pathExport")
        }
    }
}

// GetCover(path)
// --------------
// Gets path to cover
// Returns the cover image

func GetCover(cover: String) -> NSImage {
    let url = URL(fileURLWithPath: cover)
    let imageData = try! Data(contentsOf: url)
    return NSImage(data: imageData)!
}

// GetHoverHelp(book)
// --------------
// Gets the hovered book
// Returns a help string

func GetHoverHelp(_ book: AuthorBooks) -> String {
    return book.author + ": " + book.title
}

// ShowInFinder(url)
// ---------------------------
// Open a folder in the Finder

func ShowInFinder(url: URL?) {
    guard let url = url else {
        print ("Not a valid URL")
        return
    }
    /// This opens the actual folder:
    /// NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
    /// This selects the folder; I like that better:
    NSWorkspace.shared.activateFileViewerSelecting([url])
}

// DoesFileExists(url)
// ---------------------------------
// Checks if a file or folder exists
// Returns TRUE or FALSE

func DoesFileExists(url: URL) -> Bool {
    if FileManager.default.fileExists(atPath: url.path) {
        return true
    }
    return false
}

// ShowInTerminal(url)
// ---------------------------
// Open a folder in the Terminal

func ShowInTerminal(url: URL?) {
    guard let terminal = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Terminal") else { return }
    guard let url = url else {
        print ("Not a valid URL")
        return
    }
    let configuration = NSWorkspace.OpenConfiguration()
    NSWorkspace.shared.open([url],withApplicationAt: terminal,configuration: configuration)
}

// FancyBackground()
// --------------
// Returns a sidebar color

struct FancyBackground: NSViewRepresentable {
  func makeNSView(context: Context) -> NSVisualEffectView {
    return NSVisualEffectView()
  }
  
  func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    // Nothing to do.
  }
}
