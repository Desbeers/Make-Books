//  MakeBooksApp.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

@main
struct MakeBooksApp: App {
    /// Get the books with all options
    @StateObject var books = Books()
    @StateObject var scripts = Scripts()
    /// Saved theme setting
    @AppStorage("appTheme") var appTheme: String = "system"
    /// The Scene
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(books)
                .environmentObject(scripts)
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
                    scripts.activeSheet = .log
                    scripts.showSheet = true
                }) {
                    Text("Show log")
                }
                .keyboardShortcut("L")
                Button(action: {
                    scripts.activeSheet = .dropper
                    scripts.showSheet = true
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
