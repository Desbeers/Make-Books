//  SettingsView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

/// The preferences for Make Books
struct SettingsView: View {
    /// The body of the View
    var body: some View {
        VStack {
            TabView {
                Folders()
                    .tabItem {
                        Image(systemName: "folder"); Text("Folders")
                    }
                Pdf()
                    .tabItem {
                        Image(systemName: "doc"); Text("PDF")
                    }
            }
            .padding(40)
        }
    }
}

extension SettingsView {

    /// Select 'source' and 'export' folders
    struct Folders: View {
        /// Get the list of books
        @EnvironmentObject var books: Books
        /// Saved settings
        @AppStorage("pathBooks") var pathBooks: String = getDocumentsDirectory()
        @AppStorage("pathExport") var pathExport: String = getDocumentsDirectory()
        /// The body of the View
        var body: some View {
            VStack {
                Text("Where are your books?")
                    .font(.headline)
                HStack {
                    Label(getLastPath(pathBooks), systemImage: "square.and.arrow.up.on.square")
                        .truncationMode(.head)
                    Button {
                        selectBooksFolder(books)
                    } label: {
                        Text("Change")
                    }
                }
                Divider().padding(.vertical)
                Text("Where shall we export them?")
                    .font(.headline)
                HStack {
                    Label(getLastPath(pathExport), systemImage: "square.and.arrow.down.on.square")
                        .truncationMode(.head)
                    Button {
                        selectExportFolder()
                    } label: {
                        Text("Change")
                    }
                }
            }
        }
    }

    /// Settings for PDF export
    struct Pdf: View {
        /// Saved settings
        @AppStorage("pdfFont") var pdfFont: String = "11pt"
        @AppStorage("pdfPaper") var pdfPaper: String = "ebook"
        /// The body of the View
        var body: some View {
            VStack {
                Text("Font size")
                    .font(.headline)
                Picker(selection: $pdfFont, label: Text("Font size:")) {
                    Text("10 points").tag("10pt")
                    Text("11 points").tag("11pt")
                    Text("12 points").tag("12pt")
                    Text("14 points").tag("14pt")
                }
                .pickerStyle(RadioGroupPickerStyle())
                .horizontalRadioGroupLayout()
                .labelsHidden()
                Divider()
                    .padding(.vertical)
                Text("Paper format")
                    .font(.headline)
                Picker(selection: $pdfPaper, label: Text("Paper format:")) {
                    Text("A4 paper").tag("a4paper")
                    Text("A5 paper").tag("a5paper")
                    Text("US trade (6 by 9 inch)").tag("ebook")
                }
                .frame(width: 200)
                .labelsHidden()
            }
        }
    }
}
