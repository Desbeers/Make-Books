//  ContentView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI
import SwiftlyFolderUtilities

/// SwiftUI View  for the main content
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
                .frame(minWidth: 400)
        })
        .navigationSubtitle("Write a beautiful book")
        .animation(.default, value: books.selectedBook)
        .sheet(isPresented: $appState.showSheet, content: sheetContent)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                selectBooksFolder(books)
                selectExportFolder(books)
                Button {
                    Task {
                        await books.getFiles()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .help("Refresh the list of books")
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
