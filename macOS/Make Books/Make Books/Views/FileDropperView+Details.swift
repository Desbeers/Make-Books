//
//  FileDropperView+Details.swift
//  Make Books
//
//  Created by Nick Berendsen on 18/07/2023.
//

import SwiftUI
import SwiftlyTerminalUtilities

extension FileDropperView {

    /// SwiftUI `View` for details of the dropped Markdown file
    struct Details: View {
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        /// The state of the script
        @State private var isRunning: Bool = false
        /// The body of the `View`
        var body: some View {
            VStack {
                Text("Still writing? Drop your Markdown file here and make a PDF from it. It will be saved on your Desktop for proofreading.") // swiftlint:disable:this line_length
                    .padding()
                Spacer()
                Text("Drop a Markdown file").font(.title3)
                ZStack {
                    Image(systemName: "tray.and.arrow.down")
                        .resizable()
                        .frame(width: 160, height: 160)
                        .foregroundColor((scene.droppedURL != nil) ? .accentColor : .secondary)
                        .opacity(isRunning ? 0.1 : 1 )
                        .symbolEffect(.bounce, value: scene.droppedURL)
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            style: StrokeStyle(
                                lineWidth: 4,
                                dash: [4]
                            )
                        )
                        .foregroundColor(scene.isDropping ? .red : .secondary)
                        .frame(width: 280, height: 280)
                    if isRunning {
                        ProgressView()
                    }
                }
                if let droppedURL = scene.droppedURL {
                    Text(droppedURL.lastPathComponent)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Button {
                        makePDF(droppedURL: droppedURL)
                    } label: {
                        Text(" Make PDF")
                    }
                    .disabled(scene.droppedURL == nil || scene.droppedURL?.pathExtension != "md" || isRunning)
                }
                Spacer()
            }
            .padding()
        }
    }
}

extension FileDropperView.Details {

    /// Make a PDF from the dropped Markdown file
    /// - Parameter droppedURL: The URL of the dropped Markdown file
    func makePDF(droppedURL: URL) {
        guard
            let script = Bundle.main.url(forResource: Media.makePDF.script, withExtension: nil) else
        {
            return
        }
        Task { @MainActor in
            let arguments = ["'\(script.path)' '" + droppedURL.path + "'"]
            isRunning = true
            _ = await Terminal.runInShell(arguments: arguments)
            isRunning = false
            /// Build the Preview URL
            let file: String = (droppedURL.deletingPathExtension().lastPathComponent)
            let paths = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
            let result = paths[0].appendingPathComponent(file, conformingTo: .pdf)
            /// Add it to the scene
            scene.previewURL = .init(url: result)
        }
    }
}
