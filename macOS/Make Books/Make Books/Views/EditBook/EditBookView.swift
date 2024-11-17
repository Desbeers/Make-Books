//
//  EditBookView.swift
//  Make Books
//
//  Created by Nick Berendsen on 22/07/2023.
//

import SwiftUI

/// SwiftUI `View` for the form to edit metadata for a book
struct EditBookView: View {
    /// The book we want to edit
    let book: Book
    /// The state of the Scene
    @Environment(SceneState.self) var scene
    /// The state of the Library
    @Environment(Library.self) var library
    /// The Form values
    @State var values = Book()
    /// Error alerts
    @State var error: AlertMessage?

    /// Confirmation alerts
    @State var confirmation: AlertMessage?

    /// Focus state of the form
    @FocusState var focus: Metadata?
    /// Bool to show the collection View
    @State var showCollections: Bool = false
    /// The date of the book
    @State var date: Date = Date.now
    /// The body of the `Viehw`
    var body: some View {
        ScrollView {
            BookView.Header()
            HStack(alignment: .top) {
                BookCover.Cover(book: book)
                    .aspectRatio(contentMode: .fit)
                    .containerRelativeFrame(.horizontal) { length, _ in
                        length / 3
                    }
                    .cornerRadius(StaticSetting.cornerRadius)
                Form {
                    general
                    media
                    series
                    if values.media != .collection {
                        belongsToCollections
                    }

                    // MARK: Submit buttons

                    submitButtons
                        .padding(.vertical)
                }
                .frame(maxWidth: .infinity)
                .formStyle(.grouped)
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .task(id: book.id) {
            if !book.collectionItems.isEmpty {
                showCollections = true
            }
            values = book
            date = StaticSetting.bookDateFormatter.date(from: values.date) ?? Date.now
        }
        .errorAlert(message: $error)
        .confirmationDialog(message: $confirmation)

        .animation(.default, value: values)
        .animation(.default, value: showCollections)
    }
}

// swiftlint:disable indentation_width

/*

 New format

 if var newTypeURL = value.folderURL {
 newTypeURL = newTypeURL.appendingPathComponent(value.title, conformingTo: .makeBook)
 try content.write(to: newTypeURL, atomically: true, encoding: String.Encoding.utf8)
 }

 */

// swiftlint:enable indentation_width
