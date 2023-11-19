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
    @EnvironmentObject private var scene: SceneState
    /// The state of the Library
    @Environment(Library.self) private var library
    /// The state of Make
    @EnvironmentObject private var make: MakeState
    /// The body of the View
    var body: some View {
        VStack {
            Image(.hugeIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
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
                    Text(make.options[0].isSelected ? make.options[0].description : " ")
                        .foregroundColor(.secondary)
                }
                .disabled(!make.available(make.options[0]))
            }
            Button(
                action: {
                    scene.makeBooksSheet = true
                },
                label: {
                    buttonLabel
                }
            )
            .disabled(make.options.filter { $0.isSelected == true }.isEmpty)
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .overlay(alignment: .bottom) {
            if !make.notAvailable.isEmpty {
                Text(.init(make.notAvailable.joined(separator: "\n")))
            }
        }
        .padding(.horizontal)
        .animation(.default, value: make.options[0].isSelected)
        .sheet(isPresented: $scene.makeBooksSheet) {
            MakeView(books: books)
        }
    }
    /// The label of the button
    var buttonLabel: Text {
        switch books.count {
        case 1:
            return Text("Make '**\(scene.detailSelection.item.title)**'")
        default:
            return Text("Make \(books.count) books")
        }
    }
}
