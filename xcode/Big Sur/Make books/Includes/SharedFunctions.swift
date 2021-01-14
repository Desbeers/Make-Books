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
    let base = UserDefaults.standard.object(forKey: "pathBooksString") as? String ?? GetDocumentsDirectory()
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
            /// Save the url so next time this dialog is opened it will go to this folder.
            /// Sandbox stuff seems to be ok with that....
            UserDefaults.standard.set(result!.path, forKey: "pathBooksString")
            /// Create a persistent bookmark for the folder the user just selected
            _ = SetPersistentFileURL("pathBooks", result!)
            /// Refresh the list of songs
            books.bookList = GetBooksList()
            /// Clear the selected book (if any)
            books.bookSelected = nil
        }
    }
}
/// Export folder selection
func SelectExportFolder() {
    let base = UserDefaults.standard.object(forKey: "pathExportString") as? String ?? GetDocumentsDirectory()
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
            UserDefaults.standard.set(result!.path, forKey: "pathExportString")
            /// Create a persistent bookmark for the folder the user just selected
            _ = SetPersistentFileURL("pathExport", result!)
        }
    }
}

// Get and Set sandbox bookmarks
// -----------------------------
// Many thanks to https://www.appcoda.com/mac-apps-user-intent/

func SetPersistentFileURL(_ key: String, _ selectedURL: URL) -> Bool {
    do {
        let bookmarkData = try selectedURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
        UserDefaults.standard.set(bookmarkData, forKey: key)
        return true
    } catch let error {
        print("Could not create a bookmark because: ", error)
        return false
    }
}

func GetPersistentFileURL(_ key: String) -> URL? {
    if let bookmarkData = UserDefaults.standard.data(forKey: key) {
         do {
            var bookmarkDataIsStale = false
            let urlForBookmark = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &bookmarkDataIsStale)
            if bookmarkDataIsStale {
                print("The bookmark is outdated and needs to be regenerated.")
                _ = SetPersistentFileURL(key, urlForBookmark)
                return nil
 
            } else {
                return urlForBookmark
            }
        } catch {
            print("Error resolving bookmark:", error)
            return nil
        }
    } else {
        print("Error retrieving persistent bookmark data.")
        return nil
    }
}

// GetCover(path)
// --------------
// Gets path to cover
// Returns the cover image
// Defaults to a cover in the Assets bundle

func GetCover(cover: String) -> NSImage {
    if let persistentURL = GetPersistentFileURL("pathBooks") {
        /// Sandbox stuff...
        _ = persistentURL.startAccessingSecurityScopedResource()
        let url = URL(fileURLWithPath: cover)
        let imageData = try! Data(contentsOf: url)
        persistentURL.stopAccessingSecurityScopedResource()
        return NSImage(data: imageData)!
    } else {
        return NSImage(named: "CoverArt")!
    }
}
