//  PrefsView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Views

// The prefs in a sheet
struct PrefsSheet: View {
    @State private var selectedTab = 0
    @State var fontSize = UserDefaultsConfig.fontSize
    @State var paperSize = UserDefaultsConfig.paperSize
    @State var pathBooks = GetLastPath(UserDefaultsConfig.pathBooks)
    @State var pathExport = GetLastPath(UserDefaultsConfig.pathExport)
    @EnvironmentObject var books: Books
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Where are your books?")
                        .font(.headline)
                    HStack() {
                        Image(nsImage: GetFolderIcon(UserDefaultsConfig.pathBooks)).resizable().frame(width: 32, height: 32)
                        Text(pathBooks)
                            .truncationMode(.head)
                        Spacer()
                        Button(action: {self.SelectBooksFolder()}) {
                            Text("Change")
                        }
                    }
                    Spacer()
                    Text("Where shall we export them?")
                        .font(.headline)
                    HStack () {
                        Image(nsImage: GetFolderIcon(UserDefaultsConfig.pathExport)).resizable().frame(width: 32, height: 32)
                        Text(pathExport)
                           .truncationMode(.head)
                            Spacer()
                        Button(action: {self.SelectExportFolder()}) {
                            Text("Change")
                        }
                    }
                    Spacer()
                }
                .tabItem {
                    Image(systemName: "folder")
                    Text("General") }.tag(0).frame(width: 300.0)
                // PDF options
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Paper format")
                        .font(.subheadline)
                    Picker(selection: $paperSize, label: (Text("Paper format"))
                        ) {
                            ForEach(books.optionsPaper, id: \.self) { paper in
                                Text(paper.text).tag(paper.id)
                            }
                    }
                    .labelsHidden()
                    Spacer()
                    Text("Font size")
                        .font(.subheadline)
                    Picker(selection: $fontSize, label: Text("Font size")
                       ) {
                        ForEach(books.optionsFont, id: \.self) { font in
                            Text(font.text).tag(font.id)
                        }
                    }
                    .labelsHidden() .pickerStyle(RadioGroupPickerStyle())
                    .horizontalRadioGroupLayout()
                    Spacer()
                }
                .tabItem {
                    Image(systemName: "doc")
                    Text("PDF") }.tag(1).frame(width: 320.0)
            }
            .frame(height: 220)
        }.padding().frame(width: 380)
    }
    /// Books folder selection
    func SelectBooksFolder() {
        let dialog = NSOpenPanel();
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseFiles = false;
        dialog.canChooseDirectories = true;
        dialog.directoryURL = URL(string: UserDefaultsConfig.pathBooks)
        dialog.beginSheetModal(for: NSApp.keyWindow!) { (result) in
            if result == NSApplication.ModalResponse.OK {
                let result = dialog.url
                UserDefaultsConfig.pathBooks = result!.path
                self.pathBooks = GetLastPath(UserDefaultsConfig.pathBooks)
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
        dialog.directoryURL = URL(string: UserDefaultsConfig.pathExport)
        dialog.beginSheetModal(for: NSApp.keyWindow!) { (result) in
            if result == NSApplication.ModalResponse.OK {
                let result = dialog.url
                UserDefaultsConfig.pathExport = result!.path
                self.pathExport = GetLastPath(UserDefaultsConfig.pathExport)
            }
        }
    }
}

struct PrefsSheet_Previews: PreviewProvider {
    static var previews: some View {
        PrefsSheet()
    }
}

