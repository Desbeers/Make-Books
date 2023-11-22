//
//  Modifier+Suggestions.swift
//  Make Books
//
//  Created by Nick Berendsen on 24/07/2023.
//

import SwiftUI

extension Modifier {

/// A `ViewModifier` to make suggestions in a Form
    struct Suggestions: ViewModifier {
        /// Bool if the Field has focus
        let focus: Bool
        /// The array with suggestions
        let suggestions: [String]
        /// The value of the Field
        @Binding var value: String
        /// Bool if the popup should be presented
        @State private var popupPresented = false
        /// The suggestions to show
        @State private var filteredSuggestions: [String] = []
        /// The body of the `ViewModifier`
        func body(content: Content) -> some View {
            content
                .task(id: focus) {
                    makeSuggestions()
                }
                .task(id: value) {
                    makeSuggestions()
                }
                .popover(
                    isPresented: $popupPresented,
                    attachmentAnchor: .point(.center),
                    arrowEdge: .bottom
                ) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(filteredSuggestions, id: \.self) { suggestion in
                                Button(
                                    action: {
                                        value = suggestion
                                    },
                                    label: {
                                        Text(suggestion)
                                            .fixedSize(horizontal: true, vertical: false)
                                    }
                                )
                                .buttonStyle(.borderless)
                            }
                        }
                        .padding(10)
                    }
                    .frame(maxHeight: 200)
                }
        }

        /// Make a list of suggestions
        func makeSuggestions() {
            popupPresented = focus
            let searchMatcher = Search.Matcher(query: value)
            filteredSuggestions = suggestions
                .filter { !$0.isEmpty }
                .filter { suggestions in
                    return searchMatcher.matches(suggestions)
                }
            popupPresented = filteredSuggestions.isEmpty ? false : focus
        }
    }
}

extension View {

    /// A `ViewModifier` to make suggestions in a Form
    func suggestions(focus: Bool, suggestions: [String], value: Binding<String>) -> some View {
        modifier(Modifier.Suggestions(focus: focus, suggestions: suggestions, value: value))
    }
}
