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
    @AppStorage("appTheme") var appTheme: String = "system"
    /// The view
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                BooksView()
                    .frame(width: self.ListWidth(width: geometry.size.width))
                    //.listStyle(SidebarListStyle())
                VStack() {
                    OptionsView()
                    MakeView()
                }
            }
        }
        .frame(minWidth: 640, minHeight: 400)
        // Open the sheet if showSheet = true
        .sheet(isPresented: $books.showSheet) {
            LogSheet()
        }
        .onAppear {
            ApplyTheme(appTheme)
        }
    }
    
    func ListWidth(width: CGFloat) -> CGFloat {
        let minWidth = width * 0.35
        if minWidth > 320 {
            return minWidth
        } else {
            return 320
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Books())
    }
}
