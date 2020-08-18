//
//  TestApp.swift
//  Test
//
//  Created by Nick Berendsen on 16/08/2020.
//

import SwiftUI

@main
struct TestApp: App {
    @AppStorage("pathBooks") var pathBooks: String = FileManager.default.homeDirectoryForCurrentUser.path
    @AppStorage("pathExport") var pathExport: String = FileManager.default.homeDirectoryForCurrentUser.path

    var books = Books()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(books)
        }
        Settings {
            PrefsView().environmentObject(books)
        }
    }
}
