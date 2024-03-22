//
//  PreviewPDFView.swift
//  Make Books
//
//  Created by Nick Berendsen on 19/07/2023.
//

import SwiftUI

/// SwiftUI View for a PDF preview
struct PreviewView: View {
//    /// The preview URL to show
//    let previewURL: SceneState.PreviewURL?
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    /// The Data of the preview
    @State private var data: Data?
    /// The body of the `View`
    var body: some View {
        VStack {
            if let data {
                PDFKitRepresentedView(data)
            } else {
                ContentUnavailableView("No Preview", systemImage: "eye.slash", description: description)
            }
        }
        .task(id: scene.previewURL) {
            if let previewURL = scene.previewURL {
                data = try? Data(contentsOf: previewURL.url)
            } else {
                data = nil
            }
        }
    }

    private var description: Text {
        if scene.detailSelection.item.book == nil && scene.mainSelection != .fileDropper {
            Text("No Book selected")
        } else {
            Text("The PDF is not yet created")
        }
    }
}
