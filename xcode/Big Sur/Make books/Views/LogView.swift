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
                .font(.headline)
                .padding(.top)
            /// Debug
//            ScrollView() {
//                Text(scripts.log)
//            }
            LogView()
                .frame(width: 380)
                .border(Color.accentColor, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .background(Color("BackgroundColor"))
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
        .frame(minHeight: 300)
    }
}

// Preview
struct LogSheet_Previews: PreviewProvider {
    static var previews: some View {
        LogSheet().environmentObject(Books())
    }
}

// View the logfile in a webkit thingy
struct LogView : NSViewRepresentable {
    func makeNSView(context: Context) -> WKWebView  {
        let view = WKWebView()
        /// Transparent background (auto preview does not like this)
        view.setValue(false, forKey: "drawsBackground")
        let base = Bundle.main.url(forResource: "log", withExtension: "html")!
        let url = URL(string: "?log=" + NSHomeDirectory() + "/.cache/make-books/jslog.js", relativeTo: base)!
        view.load(URLRequest(url: url))
        return view
    }
    func updateNSView(_ view: WKWebView, context: Context) {
    }
}
