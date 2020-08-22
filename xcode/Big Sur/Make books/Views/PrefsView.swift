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
                PrefsGeneral().tabItem { Image(systemName: "gearshape"); Text("General") }.tag(0)
                PrefsFolders().tabItem { Image(systemName: "folder"); Text("Folders") }.tag(1)
                PrefsPdf().tabItem { Image(systemName: "doc"); Text("PDF") }.tag(2)
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
    @AppStorage("pathBooks") var pathBooks: String = FileManager.default.homeDirectoryForCurrentUser.path
    @AppStorage("pathExport") var pathExport: String = FileManager.default.homeDirectoryForCurrentUser.path
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
            Spacer()
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
    @AppStorage("pdfFont") var pdfFont: String = "11pt"
    @AppStorage("pdfPaper") var pdfPaper: String = "ebook"
    
    var body: some View {
        VStack() {
            Text("Paper format")
                .font(.headline)
            Picker(selection: $pdfPaper, label: Text("Select an option:")) {
                Text("A4 paper").tag("a4paper")
                Text("A5 paper").tag("a5paper")
                Text("US trade (6 by 9 inch)").tag("ebook")
            }
            Divider().padding(.vertical)
            Text("Font size")
            Picker(selection: $pdfFont, label: Text("Select an option:")) {
                Text("10 points").tag("10pt")
                Text("11 points").tag("11pt")
                Text("12 points").tag("12pt")
                Text("14 points").tag("14pt")
            }


            

//            Picker(selection: $paperSize, label: Text("Paper format")
//                ) {
//                    ForEach(optionsPaper, id: \.self) { paper in
//                        Text(paper.text).tag(paper.id)
//                    }
//            }
//            Spacer()
//            Text("Font size")
//                .font(.headline)
//            Picker(selection: $fontSize, label: Text("Paper format")
//                ) {
//                    ForEach(optionsFont, id: \.self) { font in
//                        Text(font.text).tag(font.id)
//                    }
//            }
//            .labelsHidden() .pickerStyle(RadioGroupPickerStyle())
//            .horizontalRadioGroupLayout()
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
