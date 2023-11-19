//
//  EditBookView.swift
//  Make Books
//
//  Created by Nick Berendsen on 22/07/2023.
//

import SwiftUI
import SwiftlyFolderUtilities
import SwiftlyAlertMessage

/// SwiftUI `View` for the form to edit metadata for a book
struct EditBookView: View {
    /// The book we want to edit
    let book: Book
    /// The state of the Scene
    @EnvironmentObject var scene: SceneState
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
    /// The title of the form
    @State private var title: String?
    /// Bool to show the collection View
    @State var showCollections: Bool = false
    /// The body of the `Viehw`
    var body: some View {
        VStack(spacing: 0) {
            if let title {
                HStack {
                    BookCover.Cover(book: book)
                        .aspectRatio(contentMode: .fit)
                    VStack {
                        Text(title)
                            .font(.title)
                            .foregroundStyle(.secondary)
                        Text(values.title)
                            .font(.largeTitle)
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 100)
                .background(.ultraThinMaterial)
                ScrollView {
                    Form {
                        general
                        media
                        series
                        if values.media != .collection {
                            belongsToCollections
                        }

                        // MARK: Read

                        Toggle(isOn: bind($values.hasBeenRead, default: false)) {
                            Text(Metadata.hasBeenRead.label)
                            Text(Metadata.hasBeenRead.description)
                        }

                        // MARK: Submit buttons

                        submitButtons
                    }
                }
                //.formStyle(.grouped)
            }
        }
        .frame(maxWidth: .infinity)
        .task(id: book.id) {
            if !book.collectionItems.isEmpty {
                showCollections = true
            }
            values = book
            title = book.status == .existing ? "Edit book" : "Add a new book"
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
