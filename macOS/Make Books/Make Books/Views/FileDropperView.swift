//
//  FileDropperView.swift
//  Make Books
//
//  Created by Nick Berendsen on 18/07/2023.
//

import SwiftUI
import PDFKit

/// SwiftUI `View` with a preview of a dropped Markdown file
struct FileDropperView: View {
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    /// The body of the `View`
    var body: some View {
        VStack {
            if let previewURL = scene.previewURL, previewURL.url.exist() {
                PreviewView()
            } else {
                ContentUnavailableView(
                    "No Preview",
                    systemImage: "eye.slash",
                    description: description
                )
            }
        }
        .id(scene.previewURL?.id)
        .task {
            scene.showInspector = false
        }
    }

    private var description: Text {
        if let url = scene.droppedURL {
            Text("**\(url.lastPathComponent)**\n\nMake a PDF to see the preview")
        } else {
            Text("You have not dropped a file yet")
        }
    }
}
