//  SettingsView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

/// SwiftUI View for the settings
struct SettingsView: View {
    /// The body of the View
    var body: some View {
        TabView {
            Folders()
                .tabItem {
                    Label("Folders", systemImage: "folder")
                }
            Pdf()
                .tabItem {
                    Label("PDF", systemImage: "doc")
                }
        }
        .formStyle(.grouped)
        .frame(width: 560, height: 300)
    }
}

extension SettingsView {

    /// Select 'source' and 'export' folders
    struct Folders: View {
        /// The state of the Library
        @Environment(Library.self) private var library
        /// The body of the View
        var body: some View {
            Form {
                Text("Where are your books?")
                    .font(.headline)

                LabeledContent(
                    content: {
                        Buttons.BooksFolderButton()
                            .labelStyle(.titleOnly)
                    }, label: {
                        Label(
                            FolderBookmark.getLastSelectedURL(bookmark: UserSetting.booksFolder.rawValue).lastPathComponent,
                            systemImage: "square.and.arrow.down.on.square"
                        )
                        .truncationMode(.head)
                    }
                )
                Text("Where shall we export them?")
                    .font(.headline)
                LabeledContent(
                    content: {
                        Buttons.ExportFolderButton()
                            .labelStyle(.titleOnly)
                    }, label: {
                        Label(
                            FolderBookmark.getLastSelectedURL(bookmark: UserSetting.exportFolder.rawValue).lastPathComponent,
                            systemImage: "square.and.arrow.up.on.square"
                        )
                        .truncationMode(.head)
                    }
                )
            }
            .formStyle(.grouped)
        }
    }

    /// Settings for PDF export
    struct Pdf: View {
        /// User selected font size
        @AppStorage(UserSetting.font.rawValue)
        var font: String = UserSetting.FontSize.size11.rawValue
        /// User selected paper size
        @AppStorage(UserSetting.paper.rawValue)
        var paper: String = UserSetting.PaperFormat.ebook.rawValue
        /// The body of the View
        var body: some View {
            Form {
                Text("Options for PDF export")
                    .font(.headline)
                Picker(selection: $font, label: Label("Font size", systemImage: "textformat.size")) {
                    ForEach(UserSetting.FontSize.allCases, id: \.self) { font in
                        Text(font.label)
                            .tag(font.rawValue)
                    }
                }
                Picker(selection: $paper, label: Label("Paper format", systemImage: "doc")) {
                    ForEach(UserSetting.PaperFormat.allCases, id: \.self) { paper in
                        Text(paper.label)
                            .tag(paper.rawValue)
                    }
                }
            }
        }
    }
}
