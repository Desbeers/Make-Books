//  ContentView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

/// The content of the whole application
/// - Left is the book list
/// - Right is the options and make view
struct ContentView: View {
    /// The state of the application
    @EnvironmentObject var appState: AppState
    /// Get the list of books
    @EnvironmentObject var books: Books
    /// Observe script related stuff
    @EnvironmentObject var scripts: Scripts
    /// The body of the View
    var body: some View {
        NavigationSplitView(sidebar: {
            BooksView()
        }, detail: {
            OptionsView()
                .frame(minWidth: 400, minHeight: 400)
        })
        .navigationSubtitle("Write a beautiful book")
        .sheet(isPresented: $appState.showSheet, content: sheetContent)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    selectBooksFolder(books)
                } label: {
                    Image(systemName: "square.and.arrow.up.on.square")
                }
                .help("The folder with your books: \(FolderBookmark.getLastPath(bookmark: "BooksPath"))")
                Button {
                    Task {
                        await books.getFiles()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .help("Refresh the list of books")
                Button {
                    selectExportFolder(books)
                } label: {
                    Image(systemName: "square.and.arrow.down.on.square")
                }
                .help("The export folder: \(FolderBookmark.getLastPath(bookmark: "ExportPath"))")
                Button {
                    appState.activeSheet = .dropper
                    appState.showSheet = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .help("Show Markdown dropper")
            }
        }
    }
}

extension ContentView {

    /// The content for a sheet
    @ViewBuilder func sheetContent() -> some View {
        switch appState.activeSheet {
        case .log:
            LogView()
        case .dropper:
            DropView()
        }
    }
}
