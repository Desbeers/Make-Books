//  OptionsView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Views

struct OptionsView: View {
    /// Get the books with all options
    @EnvironmentObject var books: Books
    
    @AppStorage("pathBooks") var pathBooks: String = FileManager.default.homeDirectoryForCurrentUser.path
    @AppStorage("pathExport") var pathExport: String = FileManager.default.homeDirectoryForCurrentUser.path
    @AppStorage("fontSize") var fontSize: Int = 1
    @AppStorage("paperSize") var paperSize: Int = 1
    
    /// The View
    var body: some View {
        VStack() {

            /// BEGIN `options for Make`
            /// In a ZStack because it has a background
            ZStack() {
                Image("MainBackground")
                    /// Resizable needed or else it does not risize
                    .resizable()
                    .frame(width: 300, height: 300)
                    .blendMode(.softLight)
                    .opacity(0.9)
                VStack() {
                    Divider().padding(.horizontal)
                    /// Another VStack to align the content to the left
                    VStack(alignment: .leading) {
                        /// Start the ForEach at 1, because 0 is the "clean" option at the botom
                        ForEach(1 ..< books.optionsMake.count) { index in
                            Toggle(isOn: self.$books.optionsMake[index].isSelected) {
                                Text(self.books.optionsMake[index].label).fontWeight(.bold)
                            }
                            Text(self.books.optionsMake[index].text)
                                
                                .foregroundColor(Color.secondary)
                                .lineLimit(2)
                                .frame(minHeight: 36)
                                .padding(.leading)
                            }
                    }.padding(.horizontal)
                    Divider().padding(.horizontal)
                     /// And at last, the 'clean' option
                     Toggle(isOn: self.$books.optionsMake[0].isSelected) {
                         Text(self.books.optionsMake[0].label)
                     }
                }
                /// No more ZStack
            }
            /// Warn if you really want to clean
            //if books.optionsMake[0].isSelected {
            Text(self.books.optionsMake[0].isSelected ? self.books.optionsMake[0].text : " ")
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
