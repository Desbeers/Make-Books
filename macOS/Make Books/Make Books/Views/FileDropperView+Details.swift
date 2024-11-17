//
//  FileDropperView+Details.swift
//  Make Books
//
//  Created by Nick Berendsen on 21/03/2024.
//

import SwiftUI

extension FileDropperView {

    struct Details: View {
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        /// The language for the dropped file
        @AppStorage("language") var language = "en-GB"

        @State private var font: UserSetting.FontSize = .size11
        @State private var paper: UserSetting.PaperFormat = .ebook

        /// The state of the script
        @State private var isRunning: Bool = false
        var body: some View {
            VStack {
                Text("Still writing?")
                    .font(.title)
                    .padding(.bottom)
                Text("Drop your Markdown file and make a PDF from it. It will be saved on your Desktop for proofreading.")
                    .padding()
                Form {
                    Picker(
                        selection: $language,
                        content: {
                            ForEach(scene.languages.sorted(by: <), id: \.value) { lang in
                                Text(lang.key)
                            }
                        },
                        label: {
                            Label("Language", systemImage: "flag")
                        }
                    )
                    .padding(.top)
                    Text("For proper hypernation of words you can select the language of your document")
                        .font(.footnote)
                        .foregroundColor(.gray)

                    Picker(selection: $font, label: Label("Font size", systemImage: "textformat.size")) {
                        ForEach(UserSetting.FontSize.allCases, id: \.self) { font in
                            Text(font.label)
                                .tag(font.rawValue)
                        }
                    }
                    Picker(selection: $paper, label: Label("Paper format", systemImage: "doc")) {
                        ForEach(UserSetting.PaperFormat.allCases, id: \.self) { paper in
                            Text(paper.label)
                                .tag(paper.rawValue)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .labelStyle(.iconOnly)
                Button {
                    // swiftlint:disable:next force_unwrapping
                    makePDF(droppedURL: scene.droppedURL!)
                } label: {
                    Text(" Make PDF")
                }
                .padding()
                .disabled(scene.droppedURL == nil || scene.droppedURL?.pathExtension != "md" || isRunning)
            }
        }

        /// Make a PDF from the dropped Markdown file
        /// - Parameter droppedURL: The URL of the dropped Markdown file
        func makePDF(droppedURL: URL) {
            guard let script = Bundle.main.url(forResource: Media.makePDF.script, withExtension: nil) else {
                return
            }
            Task { @MainActor in

                var makeArgs = "'\(script.path)' '" + droppedURL.path + "' "
                makeArgs += "--gui mac "
                makeArgs += "--paper " + paper.rawValue + " "
                makeArgs += "--font " + font.rawValue + " "
                makeArgs += "--lang " + language

                isRunning = true
                _ = await Terminal.runInShell(arguments: [makeArgs])
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
}
