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
    /// The view
    
    @AppStorage("pathBooks") var pathBooks: String = FileManager.default.homeDirectoryForCurrentUser.path
    @AppStorage("pathExport") var pathExport: String = FileManager.default.homeDirectoryForCurrentUser.path

    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                BooksView()
                    .frame(width: self.ListWidth(width: geometry.size.width))
                    .listStyle(SidebarListStyle())
                VStack() {
                    OptionsView()
                    MakeView()
                }
                
            }
        }
        // Open the sheet if showSheet = true
        .sheet(isPresented: $books.showSheet) {
            if self.books.activeSheet == "log" {
                LogSheet(showLog: self.$books.showSheet).environmentObject(self.books)
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
