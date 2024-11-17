//
//  Buttons.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

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
            FolderBookmark.SelectFolderButton(
                bookmark: UserSetting.booksFolder.rawValue,
                message: "Select the folder with your books",
                confirmationLabel: "Select",
                buttonLabel: "Books",
                buttonSystemImage: "square.and.arrow.down.on.square"
            ) {
                Task { @MainActor in
                    scene.mainSelection = .books
                    await library.getAllBooks()
                }
            }
        }
    }
}

extension Buttons {

    /// SwiftUI `View` to select the Export folder
    struct ExportFolderButton: View {
        /// The body of the `View`
        var body: some View {
            FolderBookmark.SelectFolderButton(
                bookmark: UserSetting.exportFolder.rawValue,
                message: "Select the export folder for your books",
                confirmationLabel: "Select",
                buttonLabel: "Export",
                buttonSystemImage: "square.and.arrow.up.on.square"
            ) {
                // No action needed
            }
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
