//  OptionsView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Views

struct OptionsView: View {
    /// Get the books with all options
    @EnvironmentObject var books: Books
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
                    .frame(width: 480, height: 480)
                    //.blendMode(.softLight)
                    .opacity(0.1)
                VStack(alignment: .leading) {
                    /// Another VStack to align the content to the left
                    VStack(alignment: .leading) {
                        /// Start the ForEach at 1, because 0 is the "clean" option at the botom
                        ForEach(1 ..< books.optionsMake.count) { index in
                            Toggle(isOn: $books.optionsMake[index].isSelected) {
                                Text(books.optionsMake[index].label).fontWeight(.bold)
                            }
                            Text(books.optionsMake[index].text)
                                .foregroundColor(Color.secondary)
                                .lineLimit(2)
                                .frame(minHeight: 36)
                                .padding(.leading)
                            }
                    }.padding(.horizontal)
                }
                /// No more ZStack
            }
            /// And at last, the 'clean' option
            Toggle(isOn: $books.optionsMake[0].isSelected) {
                Text(books.optionsMake[0].label)
            }
            .help(books.optionsMake[0].text)
            /// Warn if you really want to clean
            Text(books.optionsMake[0].isSelected ? books.optionsMake[0].text : " ")
                .font(.caption)
                .foregroundColor(Color.secondary)
                .animation(.easeInOut)
            /// END `options for Make`
            /// Make sure all stays on top when risizing the window
            /// Two Spacers because it should twice space as much than between settings and buttons
            Spacer()
            Spacer()
        }
    }
}

// Preview
struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(Books())
    }
}
