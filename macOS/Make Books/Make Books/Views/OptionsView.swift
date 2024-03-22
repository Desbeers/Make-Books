//
//  OptionsView.swift
//  Make Books
//
//  Created by Nick Berendsen on 21/07/2023.
//

import SwiftUI

/// SwiftUI View for all the options
struct OptionsView: View {
    /// The book to show
    let books: [Book]
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    /// The state of the Library
    @Environment(Library.self) private var library
    /// The state of Make
    @Environment(MakeState.self) private var make
    /// The body of the View
    var body: some View {
        @Bindable var scene = scene
        @Bindable var make = make
        VStack {
            Form {
                /// Start the ForEach at 1, because 0 is the "clean" option at the botom
                ForEach(1 ..< make.options.count, id: \.self) { index in
                    Toggle(isOn: $make.options[index].isSelected) {
                        Text(make.options[index].label)
                            .fontWeight(.bold)
                        Text(make.options[index].description)
                            .foregroundColor(.secondary)
                    }
                    .disabled(!make.available(make.options[index]))
                    .padding(.bottom)
                }
                /// And at last, the 'clean' option
                Toggle(isOn: $make.options[0].isSelected) {
                    Label(make.options[0].label, systemImage: "eraser")
                }
                .disabled(!make.available(make.options[0]))
                Text(make.options[0].isSelected ? make.options[0].description : " ")
                    .foregroundColor(.secondary)
            }
            .scrollContentBackground(.hidden)
            Button(
                action: {
                    scene.makeBooksSheet = true
                },
                label: {
                    buttonLabel
                }
            )
            .disabled(make.options.filter { $0.isSelected == true }.isEmpty)
            .padding([.horizontal, .bottom])
        }
        .animation(.default, value: make.options[0].isSelected)
        .sheet(isPresented: $scene.makeBooksSheet) {
            MakeView(books: books)
        }
    }
    /// The label of the button
    var buttonLabel: Text {
        switch books.count {
        case 1:
            return Text("Make '**\(books.first?.title ?? "")**'")
        default:
            return Text("Make \(books.count) books")
        }
    }
}
