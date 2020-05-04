//  ObservableOjects.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

class Books: ObservableObject {
    @Published var bookList = GetBooks()
    @Published var bookSelected: MetaBooks?
    //@Published var optionsPaper = PaperOptions()
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

func PaperOptions() -> [Options] {
    var options = [Options]()
    /// The options
    options.append(Options(id: 0, system: "a4paper", text: "A4 paper"))
    options.append(Options(id: 1, system: "a5paper", text: "A5 paper"))
    options.append(Options(id: 2, system: "ebook", text: "US trade (6 by 9 inch)"))
    /// Return options
    return options
}

func MakeOptions() -> [Make] {
    var options = [Make]()
    /// The options
    options.append(Make(make: "clean", label: "Clean all files before processing",
                        text: "Be carefull, all exports will be removed!", isSelected: false))
    options.append(Make(make: "pdf", label: "Make PDF",
                        text: "A PDF ment for screen, with cover and coloured background.", isSelected: true))
    options.append(Make(make: "print", label: "Make printable file",
                        text: "Also a PDF, however, no cover and a white background. Good for printing.", isSelected: false))
    options.append(Make(make: "epub", label: "Make ePub book",
                        text: "An ePub with cover; ready for any  reader that supports ePubs.", isSelected: false))
    options.append(Make(make: "eproof", label: "Make ePub proofread",
                        text: "An ePub you can import in Apple Books as \"proofread\".", isSelected: false))
    options.append(Make(make: "kindle", label: "Make Kindle book",
                        text: "A .mobi file that is suitable for Amazon Kindle e-readers.", isSelected: false))
    //options.append(Make(make: "md", label: "Make Markdown file", text: "Glue all your seperate book files into one Markdown file.", isSelected: false))
    //options.append(Make(make: "html", label: "Make HTML file", text: "A \"one page\" HTML file including all images and styles.", isSelected: false))
    //options.append(Make(make: "tex", label: "Make LaTeX file", text: "Covert your Markdown into a LaTeX document.", isSelected: false))
    //options.append(Make(make: "docx", label: "Make Word document", text: "Just because it is possible... Not very well supported.", isSelected: false))
    /// Return options
    return options
}

func FontOptions() -> [Options] {
    var options = [Options]()
    /// The options
    options.append(Options(id: 0, system: "10pt", text: "10 points"))
    options.append(Options(id: 1, system: "11pt", text: "11 points"))
    options.append(Options(id: 2, system: "12pt", text: "12 points"))
    options.append(Options(id: 3, system: "14pt", text: "14 points"))
    /// Return options
    return options
}
