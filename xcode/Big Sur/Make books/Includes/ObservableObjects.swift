//  ObservableOjects.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

class Books: ObservableObject {
    var bookList = GetBooks()
    @Published var bookSelected: MetaBooks?
    let optionsPaper = PaperOptions()
    let optionsFont = FontOptions()
    @Published var optionsMake = MakeOptions()
    /// State of zsh scripts
    @Published var scripsRunning = false
    /// Show sheet with log or prefs
    @Published var showSheet = false
    /// The types of sheet to show; "log" or "sheet"
    @Published var activeSheet = "log"
}

// MARK: - Structs

struct Options: Hashable {
    var id: Int
    var system: String
    var text: String
}

struct Make: Identifiable {
    var id = UUID()
    var make: String
    var label: String
    var text: String
    var isSelected: Bool
}

// MARK: - Options

func MakeOptions() -> [Make] {
    var options = [Make]()
    /// The options
    options.append(Make(make: "clean", label: "Clean all files before processing",
                        text: "Be carefull, all exports will be removed!", isSelected: false))
    options.append(Make(make: "pdf", label: "Make a PDF",
                        text: "A PDF ment for screen, with cover and a coloured background. Good for reading on screen.", isSelected: true))
    options.append(Make(make: "print", label: "Make a printable file",
                        text: "This is also a PDF, however, no cover and has a white background. Good for printing.", isSelected: false))
    options.append(Make(make: "epub", label: "Make an ePub book",
                        text: "A modern ePub; ready for any reader that supports ePubs; like any reader should do.", isSelected: false))
    options.append(Make(make: "kobo", label: "Make a Kobo book",
                        text: "Make an ePub that is optimised for the Kobo e-reader.", isSelected: false))
    return options
}

func FontOptions() -> [Options] {
    var options = [Options]()
    /// The options
    options.append(Options(id: 0, system: "10pt", text: "10 points"))
    options.append(Options(id: 1, system: "11pt", text: "11 points"))
    options.append(Options(id: 2, system: "12pt", text: "12 points"))
    options.append(Options(id: 3, system: "14pt", text: "14 points"))
    return options
}

func PaperOptions() -> [Options] {
    var options = [Options]()
    /// The options
    options.append(Options(id: 0, system: "a4paper", text: "A4 paper"))
    options.append(Options(id: 1, system: "a5paper", text: "A5 paper"))
    options.append(Options(id: 2, system: "ebook", text: "US trade (6 by 9 inch)"))
    return options
}
