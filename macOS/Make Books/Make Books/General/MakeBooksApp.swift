//
//  MakeBooksApp.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

/// SwiftUI `Scene` for the application`
@main struct MakeBooksApp: App {
    /// The state of the Scene
    @State private var scene = SceneState()
    /// The state of the Library
    @State private var library = Library()
    /// The body of the `Scene`
    var body: some Scene {
        Window("Make Books", id: "makeBooks") {
            MainView()
                .environment(scene)
                .environment(library)
                .frame(minWidth: 950, minHeight: 600)
        }
        .windowResizability(.contentSize)
        .defaultPosition(.center)
        .windowToolbarStyle(.unified(showsTitle: true))
        .commands {
            CommandGroup(after: .newItem) {
                Divider()
                Button("Reload Library") {
                    Task { @MainActor in
                        scene.navigationStack = []
                        scene.mainSelection = .books
                        await library.getAllBooks()
                    }
                }
                .keyboardShortcut("r")
            }
            CommandGroup(replacing: .help) {
                // swiftlint:disable:next force_unwrapping
                Link(destination: URL(string: "https://github.com/Desbeers/Make-Books")!) {
                    Text("Make Books on GitHub")
                }
            }
        }
        Settings {
            SettingsView()
                .environment(scene)
                .environment(library)
        }
        .windowResizability(.contentSize)
    }
}
