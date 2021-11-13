//  MakeBooksApp.swift
//  Make books
//
//  Copyright © 2021 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - App: MakeBooksApp

// The application scene

@main
struct MakeBooksApp: App {
    /// Get the list of books
    @StateObject var books = Books()
    /// Observe script related stuff
    @StateObject var scripts = Scripts()
    /// Saved theme setting
    @AppStorage("appTheme") var appTheme: String = "system"
    // START body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(books)
                .environmentObject(scripts)
                .background(Color("BackgroundColor"))
//                /// Apply the theme setting
//                .onAppear {
//                    applyTheme(appTheme)
//                }
        }
        .windowToolbarStyle(DefaultWindowToolbarStyle())
        .commands {
            /// Show or hide the sidebar
            SidebarCommands()
            CommandGroup(after: .sidebar) {
                Button {
                    scripts.activeSheet = .log
                    scripts.showSheet = true
                }
                label: {
                    Text("Show log")
                }
                .keyboardShortcut("L")
                Button {
                    scripts.activeSheet = .dropper
                    scripts.showSheet = true
                }
                label: {
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
