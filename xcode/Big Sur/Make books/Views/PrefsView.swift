//  PrefsView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Views

struct PrefsView: View {
    /// The View
    var body: some View {
        VStack {
            TabView() {
                PrefsGeneral().tabItem { Image(systemName: "gearshape"); Text("General") }
                PrefsFolders().tabItem { Image(systemName: "folder"); Text("Folders") }
                PrefsPdf().tabItem { Image(systemName: "doc"); Text("PDF") }
            }
            .padding(40)
        }
    }
}

struct PrefsGeneral: View {
    // Saved settings
    @AppStorage("appTheme") var appTheme: String = "system"
    // The View
    var body: some View {
        VStack {
            Text("The look of the application")
                .font(.headline)
            Picker(selection: $appTheme, label: Text("Select an option:")) {
                Text("Light").tag("light")
                Text("Dark").tag("dark")
                Text("System default").tag("system")
            }
            .pickerStyle(RadioGroupPickerStyle())
            .horizontalRadioGroupLayout()
            .labelsHidden()
            // Direcly apply the selection.
            .onChange(of: appTheme) { ApplyTheme($0) }
        }
    }
}

struct PrefsFolders: View {
    // Get the books with all options
    @EnvironmentObject var books: Books
    // Saved settings
    @AppStorage("pathBooksString") var pathBooks: String = GetDocumentsDirectory()
    @AppStorage("pathExportString") var pathExport: String = GetDocumentsDirectory()
    // The View
    var body: some View {
        VStack() {
            Text("Where are your books?")
                .font(.headline)
            HStack() {
                Label(GetLastPath(pathBooks), systemImage: "square.and.arrow.up.on.square").truncationMode(.head)
                Button(action: {SelectBooksFolder(books)}) {
                    Text("Change")
                }
            }
            Divider().padding(.vertical)
            Text("Where shall we export them?")
                .font(.headline)
            HStack () {
                Label(GetLastPath(pathExport), systemImage: "square.and.arrow.down.on.square").truncationMode(.head)
                Button(action: {SelectExportFolder()}) {
                    Text("Change")
                }
            }
        }
    }
}


struct PrefsPdf: View {
    // Saved settings
    @AppStorage("pdfFont") var pdfFont: String = "11pt"
    @AppStorage("pdfPaper") var pdfPaper: String = "ebook"
    // The View
    var body: some View {
        VStack() {
            Text("Font size").font(.headline)
            Picker(selection: $pdfFont, label: Text("Font size:")) {
                Text("10 points").tag("10pt")
                Text("11 points").tag("11pt")
                Text("12 points").tag("12pt")
                Text("14 points").tag("14pt")
            }
            .pickerStyle(RadioGroupPickerStyle())
            .horizontalRadioGroupLayout()
            .labelsHidden()
            Divider().padding(.vertical)
            Text("Paper format").font(.headline)
            Picker(selection: $pdfPaper, label: Text("Paper format:")) {
                Text("A4 paper").tag("a4paper")
                Text("A5 paper").tag("a5paper")
                Text("US trade (6 by 9 inch)").tag("ebook")
            }
            // BUG: Below makes the app crash when switching tabs.
            /// .labelsHidden()
        }
    }
}

// MARK: Previews

struct PrefsView_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView()
    }
}

struct PrefsGeneral_Previews: PreviewProvider {
    static var previews: some View {
        PrefsGeneral()
    }
}

struct PrefsFolders_Previews: PreviewProvider {
    static var previews: some View {
        PrefsFolders()
    }
}

struct PrefsPdf_Previews: PreviewProvider {
    static var previews: some View {
        PrefsPdf()
    }
}
