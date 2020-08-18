//  PrefsView.swift
//  Make books
//
//  Copyright © 2020 Nick Berendsen. All rights reserved.

import SwiftUI

// MARK: - Views

struct PrefsView: View {
    
    /// Get the books with all options
    @EnvironmentObject var books: Books
    
    @AppStorage("pathBooks") var pathBooks: String = FileManager.default.homeDirectoryForCurrentUser.path
    @AppStorage("pathExport") var pathExport: String = FileManager.default.homeDirectoryForCurrentUser.path
    @AppStorage("fontSize") var fontSize: Int = 1
    @AppStorage("paperSize") var paperSize: Int = 1
    
    let optionsPaper = PaperOptions()
    let optionsFont = FontOptions()
    
    ///@State private var selectedTab = 0
    ///@State var fontSize = UserDefaultsConfig.fontSize
    ///@State var paperSize = UserDefaultsConfig.paperSize
    ///@State var pathBooks = GetLastPath(UserDefaultsConfig.pathBooks)
    ///@State var pathExport = GetLastPath(UserDefaultsConfig.pathExport)
    ///@EnvironmentObject var books: Books
    var body: some View {
        VStack {
            TabView() {

                VStack(alignment: .leading) {
                    Text("Where are your books?")
                        .font(.headline)
                    HStack() {
                        Label(pathBooks, systemImage: "square.and.arrow.up.on.square").truncationMode(.head)
                        Spacer()
                        Button(action: {SelectBooksFolder(books)}) {
                            Text("Change")
                        }
                    }
                    Spacer()
                    Text("Where shall we export them?")
                        .font(.headline)
                    HStack () {
                        Label(pathExport, systemImage: "square.and.arrow.down.on.square").truncationMode(.head)
                            Spacer()
                        Button(action: {SelectExportFolder()}) {
                            Text("Change")
                        }
                    }
                    Spacer()
                }
                .tabItem {
                    Image(systemName: "folder")
                    Text("Folder locations") }.tag(1)
                .frame(width:340)
                // PDF options
                VStack(alignment: .leading) {
                    Spacer()
                    Text("Paper format")
                        .font(.headline)
                    Picker(selection: $paperSize, label: (Text("Paper format"))
                        ) {
                            ForEach(optionsPaper, id: \.self) { paper in
                                Text(paper.text).tag(paper.id)
                            }
                    }
                    
                    Spacer()
                    Text("Font size")
                        .font(.headline)
                    Picker(selection: $fontSize, label: Text("Font size")
                       ) {
                        ForEach(optionsFont, id: \.self) { font in
                            Text(font.text).tag(font.id)
                        }
                    }
                    .labelsHidden() .pickerStyle(RadioGroupPickerStyle())
                    .horizontalRadioGroupLayout()
                    Spacer()
                }
                .tabItem {
                    Image(systemName: "doc")
                    Text("PDF export") }.tag(2)
                .frame(width:340)
            }
            
        }
        .padding()
        .frame(width:360)
    }
}



struct PrefsSheet_Previews: PreviewProvider {
    static var previews: some View {
        PrefsView()
    }
}

