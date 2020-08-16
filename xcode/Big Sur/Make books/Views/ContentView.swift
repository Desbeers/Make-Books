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
    /// Get selected menu items
    private let showLogMenuItemSelected = NotificationCenter.default
        .publisher(for: .showLog)
        .receive(on: RunLoop.main)
    private let showPrefsMenuItemSelected = NotificationCenter.default
        .publisher(for: .showPrefs)
        .receive(on: RunLoop.main)
    /// The view
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                BooksView()
                    .frame(width: self.ListWidth(width: geometry.size.width))
                VStack() {
                    OptionsView()
                    MakeView()
                }
                
            }
        }
        /// Do something with menu selections
        .onReceive(showLogMenuItemSelected) { _ in self.books.showSheet.toggle(); self.books.activeSheet = "log" }
        .onReceive(showPrefsMenuItemSelected) { _ in self.books.showSheet = true; self.books.activeSheet = "prefs" }
        // Open the sheet if showSheet = true
        .sheet(isPresented: $books.showSheet) {
            if self.books.activeSheet == "log" {
                LogSheet(showLog: self.$books.showSheet).environmentObject(self.books)
            }
            else {
                PrefsSheet(showPrefs: self.$books.showSheet).environmentObject(self.books)
            }
        }
    }
    func ListWidth(width: CGFloat) -> CGFloat {
        let minWidth = width * 0.35
        if minWidth > 220 {
            return minWidth
        } else {
            return 220
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Books())
    }
}
