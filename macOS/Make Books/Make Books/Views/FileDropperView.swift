//
//  FileDropperView+Details.swift
//  Make Books
//
//  Created by Nick Berendsen on 18/07/2023.
//

import SwiftUI
import SwiftlyTerminalUtilities

/// SwiftUI `View` for details of the dropped Markdown file
struct FileDropperView: View {
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    /// The state of the script
    @State private var isRunning: Bool = false
    /// The language for the dropped file
    @AppStorage("language") var language = "en-GB"
    /// The body of the `View`
    var body: some View {
        VStack {
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
                ProgressView()
                    .opacity(isRunning ? 1 : 0 )
            }
            Text(scene.droppedURL?.lastPathComponent ?? "")
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .padding()
    }
}
