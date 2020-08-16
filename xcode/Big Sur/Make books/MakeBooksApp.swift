//
//  TestApp.swift
//  Test
//
//  Created by Nick Berendsen on 16/08/2020.
//

import SwiftUI

@main
struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Books())
        }
        Settings {
                    PrefsSheet().environmentObject(Books())
                }
    }
}
