//  ContentView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

/// The content of the whole application
/// - Left is the book list
/// - Right is the options and make view
struct ContentView: View {
    /// Get the list of books
    @EnvironmentObject var books: Books
    /// Observe script related stuff
    @EnvironmentObject var scripts: Scripts
    /// Saved settings
    @AppStorage("pathBooks") var pathBooks: String = getDocumentsDirectory()
    @AppStorage("pathExport") var pathExport: String = getDocumentsDirectory()
    var body: some View {
        NavigationSplitView(sidebar: {
            BooksView()
        }, detail: {
            OptionsView()
                .frame(minWidth: 400, minHeight: 400)
        })
        .navigationSubtitle("Write a beautiful book")
        .sheet(isPresented: $scripts.showSheet, content: sheetContent)
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    selectBooksFolder(books)
                } label: {
                    Image(systemName: "square.and.arrow.up.on.square")
                }
                .help("The folder with your books: " + getLastPath(pathBooks))
                Button {
                    withAnimation {
                        books.bookList = GetBooksList()
                        books.bookSelected = nil
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .help("Refresh the list of books")
                Button {
                    selectExportFolder()
                } label: {
                    Image(systemName: "square.and.arrow.down.on.square")
                }
                .help("The export folder: " + getLastPath(pathExport))
                Button {
                    scripts.activeSheet = .dropper
                    scripts.showSheet = true
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
        switch scripts.activeSheet {
        case .log:
            LogView()
        case .dropper:
            DropView()
        }
    }
}
