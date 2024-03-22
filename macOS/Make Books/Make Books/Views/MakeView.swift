//
//  MakeView.swift
//  Make Books
//
//  Created by Nick Berendsen on 22/07/2023.
//

import SwiftUI

/// SwiftUI `View` for the 'make' progress
struct MakeView: View {
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    /// The state of Make
    @Environment(MakeState.self) private var make
    /// The array of ``Book`` to 'make'
    let books: [Book]
    /// The body of the `View`
    var body: some View {
        VStack {
            Text(make.scriptIsRunning ? "Processing" : "Done")
                .font(.largeTitle)
                .padding(.top)
            ScrollView {
                ScrollViewReader { value in
                    ForEach(make.log) { line in
                        VStack {
                            HStack {
                                Label {
                                    Text(line.message)
                                } icon: {
                                    Image(systemName: line.symbol)
                                        .foregroundColor(line.color)
                                        .frame(minWidth: 40)
                                }
                                Spacer()
                            }
                            .font(line.type == .action ? .headline : .body)
                            .padding(.horizontal)
                            Divider()
                        }
                    }
                    /// Just use this as anchor point to keep the scrollview at the bottom
                    Divider()
                        .opacity(0)
                        .id(1)
                        .onChange(of: make.log) {
                            value.scrollTo(1)
                        }
                }
                .padding(.top)
            }
            .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)
            .border(Color.accentColor, width: 1)
            .padding(.horizontal)
            VStack {
                if make.scriptIsRunning {
                    ProgressView()
                } else {
                    Button("Close") {
                        scene.makeBooksSheet = false
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .frame(minHeight: 40)
        }
        .padding(.bottom)
        .frame(minWidth: 420, minHeight: 380)
        .task {
            make.makeBooks(books: books)
        }
    }
}
