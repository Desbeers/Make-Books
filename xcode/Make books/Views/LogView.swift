//  LogView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI
import WebKit

// The sheet view
// --------------
// showLog: show the log file
// scripsRunning: the scripts are buzy

struct LogSheet: View {
    @Binding var showLog: Bool
    
    @EnvironmentObject var books: Books

    var body: some View {
        VStack {
            Text(self.books.scripsRunning ? "Processing" : "Done")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.top)
            LogView().frame(width: 380)
                .border(Color.accentColor, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).background(/*@START_MENU_TOKEN@*/Color("LogColour")/*@END_MENU_TOKEN@*/).padding(.horizontal)
            Button("Close") {
                self.showLog = false
            }.disabled(self.books.scripsRunning)
        }.padding(.bottom).frame(minHeight: 300)
    }
}

// Preview
struct LogSheet_Previews: PreviewProvider {
    static var previews: some View {
        LogSheet(showLog: .constant(true))
    }
}

// View the logfile in a webkit thingy.
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
