//  MakeBooksApp.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

@main
struct MakeBooksApp: App {
    /// Get the books with all options
    @StateObject var books = Books()
    /// Saved theme setting
    @AppStorage("appTheme") var appTheme: String = "system"
    /// The Scene
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(books)
                .background(Color("BackgroundColor"))
                /// Apply the theme setting.
                .onAppear {
                    ApplyTheme(appTheme)
                }
        }
        .windowToolbarStyle(DefaultWindowToolbarStyle())
        .commands {
            /// Show or hide the sidebar
            SidebarCommands()
            CommandGroup(after: .sidebar)  {
                Button(action: {
                    books.activeSheet = .log
                    books.showSheet = true
                }) {
                    Text("Show log")
                }
                .keyboardShortcut("L")
                Button(action: {
                    books.activeSheet = .dropper    
                    books.showSheet = true
                }) {
                    Text("Show Markdown dropper")
                }
                .keyboardShortcut("D")
            }
        }
        Settings {
            PrefsView()
                .environmentObject(books)
                .frame(width: 500)
        }
    }
}
