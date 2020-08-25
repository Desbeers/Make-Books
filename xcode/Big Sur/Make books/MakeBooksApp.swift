//  MakeBooksApp.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

@main
struct MakeBooksApp: App {
    /// Get the books with all options
    var books = Books()
    /// The Scene
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(books)
                .frame(minWidth: 640, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        }
        .commands {
            /// Show or hide the sidebar
            SidebarCommands()
        }
        Settings {
            PrefsView()
                .environmentObject(books)
                .frame(width: 500)
        }
    }
}
