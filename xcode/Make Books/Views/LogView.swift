//  LogView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

/// SwiftUI View for the log
struct LogView: View {
    /// The state of the application
    @EnvironmentObject var appState: AppState
    /// Get the list of books
    @EnvironmentObject var books: Books
    /// Observe script related stuff
    @EnvironmentObject var scripts: Scripts
    /// The body of the View
    var body: some View {
        VStack {
            Text(scripts.isRunning ? "Processing" : "Done")
                .font(.largeTitle)
                .padding(.top)
            ScrollView {
                ScrollViewReader { value in
                    ForEach(scripts.log) { line in
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
                    Divider().opacity(0).id(1)
                        .onChange(of: scripts.log) { _ in
                            value.scrollTo(1)
                        }
                }
                .padding(.top)
            }
            .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)
            .border(Color.accentColor, width: 1)
            .padding(.horizontal)
            VStack {
                if scripts.isRunning {
                    ProgressView()
                } else {
                    Button("Close") {
                        appState.showSheet = false
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .frame(minHeight: 40)
        }
        .padding(.bottom)
        .frame(minWidth: 420, minHeight: 380)
    }
}
