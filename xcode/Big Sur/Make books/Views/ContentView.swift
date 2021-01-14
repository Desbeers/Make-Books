//  ContentView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

//  MARK: - Views: Content View

/// The content of the whole application.
/// - Left is the book list
/// - Right is the options and buttons view

struct ContentView: View {
    /// Get the books with all options
    @EnvironmentObject var books: Books
    /// Saved settings
    //@AppStorage("appTheme") var appTheme: String = "system"
    @AppStorage("pathBooksString") var pathBooks: String = GetDocumentsDirectory()
    @AppStorage("pathExportString") var pathExport: String = GetDocumentsDirectory()
    /// The view
    var body: some View {
        NavigationView  {
            BooksView()
            VStack() {
                OptionsView()
                MakeView()
            }
            .frame(minWidth: 420)
        }
        .navigationSubtitle(books.bookSelected != nil ? books.bookSelected!.title : "Write a beautifull book")
        /// Open the sheet if showSheet = true
        .sheet(isPresented: $books.showSheet) {
            LogSheet()
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    SelectBooksFolder(books)
                } ) {
                    HStack {
                    Image(systemName: "square.and.arrow.up.on.square")
                    //Text(GetLastPath(pathBooks))
                    }
                }
                .help("The folder with your books: " + GetLastPath(pathBooks))
            }
            ToolbarItem {
                 Button(action: {
                    SelectExportFolder()
                } ) {
                    Image(systemName: "square.and.arrow.down.on.square")
                    //Text(GetLastPath(pathExport))
                }
                .help("The export folder: " + GetLastPath(pathExport))
            }
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                } ) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Books())
    }
}
