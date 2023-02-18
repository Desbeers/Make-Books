//  MakeBooksApp.swift
//  Make books
//
//  © 2023 Nick Berendsen

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
    /// The body of the View
    var body: some Scene {
        Window("Make Books", id: "main") {
            ContentView()
                .environmentObject(books)
                .environmentObject(scripts)
                .background(Color("BackgroundColor"))
        }
        .windowToolbarStyle(.automatic)
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
            SettingsView()
                .environmentObject(books)
                .frame(width: 500)
        }
    }
}
