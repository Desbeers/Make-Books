//
//  Modifier+FileDropper.swift
//  Make Books
//
//  Created by Nick Berendsen on 21/07/2023.
//

import SwiftUI
import UniformTypeIdentifiers

extension Modifier {

    // MARK: File Dropper Modifier

    /// A `ViewModifier` to animate the navigation stack
    struct FileDropper: ViewModifier {
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        /// The state of the Library
        @Environment(Library.self) private var library
        /// The modifier
        func body(content: Content) -> some View {
            @Bindable var scene = scene
            content
            /// Below avoids opening a new Window when dropping a file on the App Icon or into the Window
            .handlesExternalEvents(preferring: ["*"], allowing: ["*"])
            /// Handle dropped files on the App Icon
            .onOpenURL { url in
                handleDrop(url: url)
            }
            .onDrop(of: [.fileURL], isTargeted: $scene.isDropping) { items in

                if let item = items.first {
                    item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { urlData, _ in
                        Task { @MainActor in
                            if let urlData = urlData as? Data {
                                let url = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                                handleDrop(url: url)
                            }
                        }
                    }
                }
                return true
            }
        }

        /// Handle the dropped URL
        /// - Parameter url: The URL that was dropped
        func handleDrop(url: URL) {
            switch url.pathExtension {
            case "makebook":
                if let book = library.books.first(where: { $0.makebookURL == url }) {
                    scene.navigationStack.append(.book(book: book))
                }
            case "md":
                NSSound(named: "Submarine")?.play()
                scene.droppedURL = url
                scene.mainSelection = .fileDropper
            default:
                NSSound(named: "Tink")?.play()
            }
        }
    }
}

extension View {

    /// A `ViewModifier` to handle dropped files
    func fileDropper() -> some View {
        modifier(Modifier.FileDropper())
    }
}

// swiftlint:disable indentation_width

/*

/// When using a single Window Scene, '.onOpenURL' does not work
/// This is an alternative to observe the dropped file

 class AppDelegate: NSObject, NSApplicationDelegate {
     func application(_ sender: NSApplication, open urls: [URL]) {
        /// Use open, not openFiles!
         print("appDelegate dropped urls:", urls) // diagnostic
         if let first = urls.first, let scene {
             scene.droppedURL = first
             scene.mainSelection = .fileDropper
         }

     }
 }
*/

// swiftlint:enable indentation_width
