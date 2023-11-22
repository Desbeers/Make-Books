//
//  EditBookView+Submit.swift
//  Make Books
//
//  Created by Nick Berendsen on 25/07/2023.
//

import SwiftUI
import SwiftlyFolderUtilities

extension EditBookView {

    // MARK: Submission of the form

    /// The submit buttons for the form
    var submitButtons: some View {
        HStack {
            Button("Cancel") {
                if book != values {
                    self.confirmation = Status.BookError.unsavedData.alert {
                        goBack()
                    }
                } else {
                    goBack()
                }
            }
            Spacer()
            Group {
                switch values.status {
                case .existing:
                    Button("Update Book") {
                        confirmation = Status.BookError.overwriteFile.alert {
                            do {
                                try updateBook()
                            } catch {
                                self.error = error.alert()
                            }
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                case .new:
                    newBookButton
                        .keyboardShortcut(.defaultAction)
                }
            }
            .disabled(disableSubmit)
        }
    }

    /// Button to submit a new book
    var newBookButton: some View {
        Button(
            action: {
                Task {
                    do {
                        let url = try await FolderBookmark.select(
                            prompt: "Select",
                            message: "Select the folder for your new book",
                            bookmark: UserSetting.newBookFolder.rawValue
                        )
                        values.sourceURL = url.appendingPathComponent(values.title)
                        try await createBook()
                        /// Add the book to the library
                        library.books.append(values)
                        /// Update the DetailView
                        scene.detailSelection = .book(book: values)
                        /// Close the View and show the Book
                        goBack(book: values)
                    } catch {
                        self.error = error.alert()
                    }
                }
            },
            label: {
                Label("Create book", systemImage: "square.and.arrow.up.on.square")
            }
        )
        .help("Select the folder for your new book")
        .labelStyle(.titleOnly)
    }

    /// Bool if the submit button should be disabled
    var disableSubmit: Bool {
        return values == book ||
        values.title.isEmpty ||
        values.author.isEmpty ||
        (values.media == .collection && values.collection == nil) ||
        (values.media == .tag && values.tag == nil)
    }

    /// Create a new book
    @MainActor func createBook() throws {
        let manager = FileManager.default
        do {
            try manager.createDirectory(
                at: values.sourceURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
            try manager.createDirectory(
                at: values.assetsURL,
                withIntermediateDirectories: false,
                attributes: nil
            )
            let contentURL = values.sourceURL.appendingPathComponent(values.title, conformingTo: .markdown)
            let yamlURL = values.assetsURL.appendingPathComponent(values.media.yamlFile, conformingTo: .markdown)
            let dedicationURL = values.assetsURL.appendingPathComponent("Dedication", conformingTo: .markdown)
            let coverURL = values.assetsURL.appendingPathComponent("cover-screen.jpg")

            /// Add the URL's to the book
            values.yalmURL = yamlURL
            values.coverURL = coverURL

            if let content = values.yamlEport {
                try content.write(to: yamlURL, atomically: true, encoding: String.Encoding.utf8)
                try String("# Welcome to your new book").write(to: contentURL, atomically: true, encoding: String.Encoding.utf8)
                try String("").write(to: dedicationURL, atomically: true, encoding: String.Encoding.utf8)
            }

            /// Save the cover
            try BookCover.saveFallbackCover(book: values)

            /// Mark the book as existing
            values.status = .existing
        } catch CocoaError.fileWriteFileExists {
            throw Status.BookError.bookExtists
        } catch {
            print(error.localizedDescription)
        }
    }

    /// Update the metadata for the book
    func updateBook() throws {
        /// Update the book in the Library
        if let index = library.books.firstIndex(where: { $0.id == values.id }) {
            /// Update the Book
            library.books[index] = values
        }
        do {
            if let content = values.yamlEport, let fileURL = values.yalmURL {
                try content.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            }
        } catch {
            throw error
        }
        goBack(book: values)
    }

    func goBack(book: Book? = nil) {
        if scene.navigationStack.isEmpty {
            if let book {
                scene.mainSelection = .book(book: book)
            } else {
                scene.mainSelection = .books
            }
        } else {
            scene.navigationStack.removeLast()
            /// Replace last item in the stack with the updated book
            if let book {
                scene.navigationStack.removeLast()
                switch book.media {
                case .book:
                    scene.navigationStack.append(.book(book: book))
                case .collection:
                    scene.navigationStack.append(library.getCollectionLink(collection: book))
                case .tag:
                    scene.navigationStack.append(.tag(tag: book))
                default:
                    break
                }
            }
        }
    }
}
