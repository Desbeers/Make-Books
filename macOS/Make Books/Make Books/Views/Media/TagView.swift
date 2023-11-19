//
//  TagView.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI
import SwiftlyTerminalUtilities

/// SwiftUI `View` for a 'tag' ``Book``
struct TagView: View {
    /// The 'tag' book to show
    let tag: Book
    /// The state of the Scene
    @EnvironmentObject var scene: SceneState
    /// The files of the book
    @State private var files: [File] = []
    /// The body of the ``View``
    var body: some View {
        ScrollView {
            BookView(book: tag)
                if files.isEmpty {
                    PartsView.NoContentView()
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(files.enumerated()), id: \.element) { index, file in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(file.title)
                                    Text(file.url.lastPathComponent)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button {
                                    file.url.openInFinder()
                                } label: {
                                    Text("Open in Finder")
                                }
                            }
                            .padding(.horizontal)
                            .background {
                                Color.alternatedList.opacity(index % 2 == 0 ? 1 : 0)
                            }
                        }
                    }
                }
        }
        .task(id: tag) {
            files = []
            if let tag = tag.tag {
                let arguments = "find \'\(UserSetting.getBooksFolder)' -name '*.md' -type f -exec grep -lw '\(tag)' {} + | sort"
                let result = await Terminal.runInShell(arguments: [arguments])
                for item in result.standardOutput.components(separatedBy: .newlines) {
                    let fileURL = URL(filePath: item)
                    if
                        !StaticSetting
                            .makeBooksConfigFiles
                            .contains(fileURL.lastPathComponent),
                        let content = try? String(contentsOf: fileURL, encoding: .utf8)
                    {
                        files.append(File(title: content.components(separatedBy: .newlines).first ?? item, url: fileURL))
                    }
                }
            }
        }
    }
}

extension TagView {

    struct File: Hashable, Identifiable {
        let id: UUID = UUID()
        let title: String
        let url: URL
    }
}
