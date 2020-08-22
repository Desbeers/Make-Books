//  MakeBooksApp.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

@main
struct TestApp: App {
    /// Get the books with all options
    var books = Books()
    /// The Scene
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(books)
        }
        .commands {
            /// Show or hide the sidebar
            SidebarCommands()
        }
        Settings {
            PrefsView().environmentObject(books).frame(width: 400)
        }
    }
}
