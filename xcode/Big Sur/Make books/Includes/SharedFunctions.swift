//  SharedFunctions.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Fuctions

// GetBooks()
// ----------
// Gets the list of all books.
// The directory is set in the preferences

func GetBooks() -> [MetaBooks] {
    /// The path of the books from UserDefault
    let base = UserDefaultsConfig.pathBooks
    /// Prepair the vars
    var meta = [String: String]()
    /// Convert path to an url
    let directoryURL = URL(fileURLWithPath: base)
    // TODO: Why do I need [] here?
    var metaBooks = [MetaBooks]()
    /// Get a list of all files
    if let enumerator = FileManager.default.enumerator(atPath: directoryURL.path) {
        for case let path as String in enumerator {
            if path.hasSuffix("/make-book.md") || path.hasSuffix("/make-collection.md") || path.hasSuffix("/make-tag-book.md") {
                meta = GetMeta(base + "/" + path)
                var bookURL = URL(fileURLWithPath: (base + "/" + path))
                bookURL.deleteLastPathComponent()
                bookURL.appendPathComponent("cover-screen.jpg")
                meta["cover"] = bookURL.path
                bookURL.deleteLastPathComponent()
                bookURL.deleteLastPathComponent()
                meta["path"] = bookURL.path
                /// There are books and collections in the list
                /// Assign the correct script.
                if path.hasSuffix("/make-book.md") {
                    meta["type"] = "Book"
                    meta["script"] = "make-book"
                }
                if path.hasSuffix("/make-collection.md") {
                    meta["type"] = "Collection"
                    meta["script"] = "make-collection"
                }
                if path.hasSuffix("/make-tag-book.md") {
                    meta["type"] = meta["tag"]!
                    meta["script"] = "make-tag-book"
                }
                metaBooks.append(MetaBooks(
                    title: meta["title"]!,
                    author: meta["author"]!,
                    date: meta["date"]!,
                    cover: meta["cover"]!,
                    collection: meta["belongs-to-collection"]!,
                    position: meta["group-position"]!,
                    path: meta["path"]!,
                    type: meta["type"]!,
                    script: meta["script"]!
                ))
            }
        }
    }
    /// Sort by author name and then by date.
    metaBooks.sort { $0.author == $1.author ? $0.date < $1.date : $0.author < $1.author  }
    return metaBooks
}

struct MetaBooks: Hashable {
    var id = UUID()
    var title: String = ""
    var author: String = ""
    var date: String = ""
    var cover: String = ""
    var collection: String = ""
    var position: String = ""
    var path: String = ""
    var type: String = ""
    var script: String = ""
}

// GetMeta(path)
// -------------
// Gets the full path to the metadata file
// Read the metadata from the file
// Return an dictionary

func GetMeta(_ path: String) -> [String: String] {
    var meta = [String: String]()
    /// Below is optional in the metadata file; however, it is used in the UI
    /// so I just make sure it is there, empty if not set.
    meta["belongs-to-collection"] = ""
    meta["group-position"] = ""
    errno = 0
    if freopen((path), "r", stdin) == nil {
        perror((path))
    }
    while let line = readLine() {
        let result = line.range(of: "[a-z]", options:.regularExpression)
        if (result != nil) {
            let lineArr = line.components(separatedBy: ": ")
            meta[lineArr[0]] = lineArr[1]
        }
    }
    return meta
}

// GetCover(path)
// --------------
// Gets path to cover
// Returns the cover image
// Defaults to a cover in the Assets bundle

func GetCover(cover: String) -> NSImage {
    //let book = bookURL
    if FileManager.default.fileExists(atPath: cover) {
        let url = URL(fileURLWithPath: cover)
        let imageData = try! Data(contentsOf: url)
        return NSImage(data: imageData)!
    } else {
        return NSImage(named: "CoverArt")!
    }
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
    print(makeArgs)
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

// Folder selectors
// -------------------

/// Books folder selection
func SelectBooksFolder(_ books: Books) {
    let dialog = NSOpenPanel();
    dialog.showsResizeIndicator    = true;
    dialog.showsHiddenFiles        = false;
    dialog.canChooseFiles = false;
    dialog.canChooseDirectories = true;
    // This does not work
    ///dialog.directoryURL = URL(string: pathBooks)
    dialog.beginSheetModal(for: NSApp.keyWindow!) { (result) in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            ///UserDefaultsConfig.pathBooks = result!.path
            ///pathBooks = result!.path
            UserDefaults.standard.set(result!.path, forKey: "pathBooks")
            ///self.pathBooks = GetLastPath(UserDefaultsConfig.pathBooks)
            /// Refresh the list of books
            books.bookList = GetBooks()
            /// Clear the selected book (if any)
            books.bookSelected = nil
        }
    }
}
/// Export folder selection
func SelectExportFolder() {
    let dialog = NSOpenPanel();
    dialog.showsResizeIndicator    = true;
    dialog.showsHiddenFiles        = false;
    dialog.canChooseFiles = false;
    dialog.canChooseDirectories = true;
    // This does not work in Big Sur
    ///dialog.directoryURL = URL(string: pathExport)
    dialog.beginSheetModal(for: NSApp.keyWindow!) { (result) in
        if result == NSApplication.ModalResponse.OK {
            let result = dialog.url
            ///UserDefaultsConfig.pathExport = result!.path
            //pathExport = result!.path
            UserDefaults.standard.set(result!.path, forKey: "pathExport")
            ///self.pathExport = GetLastPath(UserDefaultsConfig.pathExport)
        }
    }
}
