//
//  Buttons.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI
import SwiftlyFolderUtilities

/// SwiftUI Button Vies
enum Buttons {
    /// Just a placeholder
}

extension Buttons {

    /// SwiftUI `View`  to select the Books folder
    struct BooksFolderButton: View {
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        /// The state of the Library
        @Environment(Library.self) private var library
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    Task {
                        do {
                            _ = try await FolderBookmark.select(
                                prompt: "Select",
                                message: "Select the folder with your books",
                                bookmark: UserSetting.booksFolder.rawValue
                            )
                            scene.mainSelection = .books
                            await library.getAllBooks()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                },
                label: {
                    Label("Select Books Folder", systemImage: "square.and.arrow.down.on.square")
                }
            )
            .help("Select the folder with your books")
        }
    }
}

extension Buttons {

    /// SwiftUI `View` to select the Export folder
    struct ExportFolderButton: View {
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    Task {
                        do {
                            _ = try await FolderBookmark.select(
                                prompt: "Select",
                                message: "Select the export folder for your books",
                                bookmark: UserSetting.exportFolder.rawValue
                            )
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                },
                label: {
                    Label("Select Export Folder", systemImage: "square.and.arrow.up.on.square")
                }
            )
            .help("Select the export folder for your books")
        }
    }
}

extension Buttons {

    /// SwiftUI `View` to select the folder for a new ``Book``
    struct NewBookFolderButton: View {
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    Task {
                        do {
                            _ = try await FolderBookmark.select(
                                prompt: "Select",
                                message: "Select the folder for your new book",
                                bookmark: UserSetting.newBookFolder.rawValue
                            )
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                },
                label: {
                    Label("Create book", systemImage: "square.and.arrow.up.on.square")
                }
            )
            .help("Select the folder for your new book")
        }
    }
}

extension Buttons {

    /// SwiftUI `View` for a Button in  the toolbar
    struct ButtonItem: View {
        /// The ``Router`` item for the button
        let router: Router
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        /// The body of the `View`
        var body: some View {
            Button(
                action: {
                    Task { @MainActor in
                        withAnimation {
                            scene.navigationStack = []
                            scene.detailSelection = router
                            scene.mainSelection = router
                        }
                    }
                },
                label: {
                    Label(router.item.title, systemImage: router.item.icon)
                        .foregroundColor(scene.mainSelection == router ? router.item.color : .primary)
                }
            )
            .help(router.item.description)
        }
    }
}
