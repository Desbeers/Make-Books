//  OptionsView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Views

struct OptionsView: View {
    /// Get the books with all options
    @EnvironmentObject var books: Books
    /// Get the Make options
    @StateObject var makeOptions = MakeOptions()
    /// The View
    var body: some View {
        VStack() {
            /// BEGIN `options for Make`
            Spacer()
            /// In a ZStack because it has a background
            ZStack() {
                Image("MainBackground")
                    /// Resizable needed or else it does not risize
                    .resizable()
                    .frame(width: 300, height: 300)
                    .opacity(0.1)
                VStack() {
                    Text("Make your book").font(.largeTitle)
                    /// Another VStack to align the content to the left
                    VStack(alignment: .leading) {
                        /// Start the ForEach at 1, because 0 is the "clean" option at the botom
                        ForEach(1 ..< makeOptions.options.count) { index in
                            Toggle(isOn: $makeOptions.options[index].isSelected) {
                                Text(makeOptions.options[index].label).fontWeight(.bold)
                            }
                            Text(makeOptions.options[index].text)
                                .foregroundColor(Color.secondary)
                                .padding(.leading)
                            }
                    }.padding(.horizontal)
                }
                /// No more ZStack
            }
            /// And at last, the 'clean' option
            Toggle(isOn: $makeOptions.options[0].isSelected) {
                Text(makeOptions.options[0].label)
            }
            .help(makeOptions.options[0].text)
            /// Warn if you really want to clean
            Text(makeOptions.options[0].isSelected ? makeOptions.options[0].text : " ")
                .font(.caption)
                .foregroundColor(Color.secondary)
                .animation(.easeInOut)
            /// END `options for Make`
            /// Make sure all stays on top when risizing the window
            /// Two Spacers because it should twice space as much than between settings and buttons
            Spacer()
            Spacer()
            MakeView(makeOptions: makeOptions)
        }
    }
}

// Preview
struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(Books())
    }
}
