//  MakeBooksApp.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

@main
struct MakeBooksApp: App {
    /// Get the books with all options
    var books = Books()
    /// Saved theme setting
    @AppStorage("appTheme") var appTheme: String = ".none"
    /// The Scene
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(books)
                .background(Color("BackgroundColor"))
                // Apply the theme setting.
                .onAppear {
                    ApplyTheme(appTheme)
                }
                //.preferredColorScheme(.dark)
            
        }
        
        .commands {
            /// Show or hide the sidebar
            SidebarCommands()
            CommandGroup(after: .sidebar)  {
                Button(action: {
                    books.showSheet = true
                }) {
                    Text("Show log")
                }
                .keyboardShortcut("L")
            }

        }
        Settings {
            PrefsView()
                .environmentObject(books)
                .frame(width: 500)
        }
    }
}
