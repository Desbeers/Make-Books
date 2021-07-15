//  ContentView.swift
//  Make books
//
//  Copyright © 2021 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - View: ContentView

// The content of the whole application.
// - Left is the book list
// - Right is the options and make view

struct ContentView: View {
    /// Get the list of books
    @EnvironmentObject var books: Books
    /// Observe script related stuff
    @EnvironmentObject var scripts: Scripts
    /// Saved settings
    @AppStorage("pathBooks") var pathBooks: String = getDocumentsDirectory()
    @AppStorage("pathExport") var pathExport: String = getDocumentsDirectory()
    // START body
    var body: some View {
        NavigationView {
            BooksView()
                .toolbar {
                    ToolbarItemGroup {
                        Button {
                            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                        } label: {
                            Image(systemName: "sidebar.left").foregroundColor(.secondary)
                        }
                        .help("Hide or show the sidebar")
                        Button {
                            withAnimation {
                                books.bookList = GetBooksList()
                                books.bookSelected = nil
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                        .help("Refresh the list of books")
                    }
                }
            OptionsView()
                .toolbar {
                    HStack {
                        Button {
                            selectBooksFolder(books)
                        } label: {
                            Image(systemName: "square.and.arrow.up.on.square").foregroundColor(.secondary)
                        }
                        .help("The folder with your books: " + getLastPath(pathBooks))
                        Button {
                            selectExportFolder()
                        } label: {
                            Image(systemName: "square.and.arrow.down.on.square").foregroundColor(.secondary)
                        }
                        .help("The export folder: " + getLastPath(pathExport))
                        Divider()
                        Button {
                            scripts.activeSheet = .dropper
                            scripts.showSheet = true
                        } label: {
                            Image(systemName: "square.and.pencil").foregroundColor(.secondary)
                        }
                        .help("Show Markdown dropper")
                    }
                }
        }
        .navigationSubtitle("Write a beautiful book")
        /// Open the sheet if showSheet = true
        .sheet(isPresented: $scripts.showSheet, content: sheetContent)
    }
}

// MARK: - Extension: ContentView

// You can only have one sheet in a view.
// This extension makes it possible to have different views.

extension ContentView {
    @ViewBuilder
    func sheetContent() -> some View {
        switch scripts.activeSheet {
        case .log:
            LogView()
        case .dropper:
            DropView()
        }
    }
}
