//  MakeBooksApp.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

// MARK: - App: MakeBooksApp

// The application scene

@main
struct MakeBooksApp: App {
    /// The state of the application
    @StateObject var appState = AppState()
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
                .environmentObject(appState)
                .environmentObject(books)
                .environmentObject(scripts)
                .background(Color(nsColor: .textBackgroundColor))
                .task {
                    await books.getFiles()
                }
        }
        .windowToolbarStyle(.automatic)
        .windowResizability(.contentMinSize)
        .commands {
            /// Show or hide the sidebar
            SidebarCommands()
            CommandGroup(after: .sidebar) {
                Button {
                    appState.activeSheet = .log
                    appState.showSheet = true
                }
                label: {
                    Text("Show log")
                }
                .keyboardShortcut("L")
                Button {
                    appState.activeSheet = .dropper
                    appState.showSheet = true
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
