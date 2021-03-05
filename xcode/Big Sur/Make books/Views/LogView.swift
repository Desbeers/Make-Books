//  LogView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI
import WebKit

// The sheet view
// --------------
// showSheet: show the log file in a sheet
// scripsRunning: the scripts are buzy

struct LogSheet: View {
    /// Get the books with all options
    @EnvironmentObject var books: Books
    /// Observe script related stuff
    @EnvironmentObject var scripts: Scripts
    /// The view
    var body: some View {
        VStack {
            Text(scripts.isRunning ? "Processing" : "Done")
                .font(.largeTitle)
                .padding(.top)
            ScrollView {
                ScrollViewReader { value in
                    ForEach(scripts.log) { line in
                        VStack() {
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
                        .onChange(of: scripts.log) { newValue in
                            value.scrollTo(1)
                        }
                }
                .padding(.top)
            }
            .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)
            .border(Color.accentColor, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            .padding(.horizontal)
            VStack() {
                if scripts.isRunning {
                    ProgressView()
                } else {
                    Button("Close") {
                        scripts.showSheet = false
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

// Preview
struct LogSheet_Previews: PreviewProvider {
    static var previews: some View {
        LogSheet().environmentObject(Books())
    }
}
