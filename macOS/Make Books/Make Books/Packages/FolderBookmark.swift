//
//  FolderBookmark.swift
//  SwiftlyFolderUtilities
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// Persistent folder bookmark utilities
public enum FolderBookmark {
    // Just a placeholder
}

// MARK: Errors

extension FolderBookmark {

    /// Errors that cann occure
    enum BookmarkError: LocalizedError {
        case notFound
        case noKeyWindow
        case noFolderSelected

        public var description: String {
            switch self {
            case .noKeyWindow:
                return "Error retrieving key window"
            case .notFound:
                return "Error retrieving persistent bookmark data"
            case .noFolderSelected:
                return "There is no folder selected"
            }
        }

        public var errorDescription: String? {
            return description
        }
    }
}

// MARK: Public structs

extension FolderBookmark {

    /// SwiftUI `View` with a button to open a `FileImporter` sheet
    public struct SelectFolderButton: View {

        let bookmark: String
        let message: String
        let confirmationLabel: String
        let buttonLabel: String
        let buttonSystemImage: String
        let action: () -> Void

        @State private var isPresented: Bool = false

        public init(
            bookmark: String,
            message: String,
            confirmationLabel: String,
            buttonLabel: String,
            buttonSystemImage: String,
            action: @escaping () -> Void
        ) {
            self.bookmark = bookmark
            self.message = message
            self.confirmationLabel = confirmationLabel
            self.buttonLabel = buttonLabel
            self.buttonSystemImage = buttonSystemImage
            self.action = action
        }

        public var body: some View {
            Button(
                action: {
                    isPresented.toggle()
                },
                label: {
                    Label(buttonLabel, systemImage: buttonSystemImage)
                }
            )
            .help(message)
            .selectFolderSheet(
                isPresented: $isPresented,
                bookmark: bookmark,
                message: message,
                confirmationLabel: confirmationLabel,
                action: action
            )
        }
    }
}

// MARK: Private structs

extension FolderBookmark {

    /// Swiftui `Modifier` to add a `FileImporter` sheet
    struct SelectFolderSheet: ViewModifier {

        @Binding var isPresented: Bool
        let bookmark: String
        let message: String
        let confirmationLabel: String
        let action: () -> Void

        func body(content: Content) -> some View {
            content
                .fileImporter(
                    isPresented: $isPresented,
                    allowedContentTypes: [.folder]
                ) { result in
                    switch result {
                    case .success(let folder):
                        _ = setPersistentFileURL(bookmark, folder)
                        action()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .fileDialogMessage(message)
                .fileDialogConfirmationLabel(confirmationLabel)
                .fileDialogCustomizationID(bookmark)
        }
    }
}

// MARK: Public functions

extension View {

    /// Swiftui `Modifier` to add a `FileImporter` sheet
    /// - Parameters:
    ///   - isPresented: Bool to show the sheet or not
    ///   - bookmark: The name of the bookmark
    ///   - message: The message in the `FileImporter` sheet
    ///   - confirmationLabel: The label of the confirmation button
    ///   - action: The action to perform when a folder is selected
    /// - Returns: A `ViewModifier` with the `FileImporter` sheet
    public func selectFolderSheet(
        isPresented: Binding<Bool>,
        bookmark: String,
        message: String,
        confirmationLabel: String,
        action: @escaping () -> Void
    ) -> some View {
        modifier(
            FolderBookmark.SelectFolderSheet(
                isPresented: isPresented,
                bookmark: bookmark,
                message: message,
                confirmationLabel: confirmationLabel,
                action: action
            )
        )
    }
}

extension FolderBookmark {

    /// Perform an action with a bookmark folder
    /// - Parameters:
    ///   - bookmark: The name of the bookmark
    ///   - action: The action for the bookmark folder
    ///
    /// - Note: When the action is running in a Task, the task itself is responsible for the start and stop of the `SecurityScopedResource`
    public static func action(bookmark: String, action: (_ url: URL) -> Void) throws {
        guard let persistentURL = try FolderBookmark.getPersistentFileURL(bookmark) else {
            throw BookmarkError.notFound
        }
        /// Make sure the security-scoped resource is released when finished
        defer {
            persistentURL.stopAccessingSecurityScopedResource()
        }
        /// Start accessing a security-scoped resource
        _ = persistentURL.startAccessingSecurityScopedResource()
        /// Execute the action
        action(persistentURL)
    }

    /// Get the last selected URL of a bookmark, if any
    /// - Parameter bookmark: The name of the bookmark
    /// - Returns: The URL of the bookmark if found, else 'Documents'
    public static func getLastSelectedURL(bookmark: String) -> URL {
        guard let persistentURL = try? FolderBookmark.getPersistentFileURL(bookmark) else {
            return FolderBookmark.getDocumentsDirectory()
        }
        return persistentURL
    }

    /// Get an optional bookmark URL
    /// - Parameter bookmark: The name of the bookmark
    /// - Returns: An optional URL
    public static func getBookmarkLink(bookmark: String) -> URL? {
        guard let persistentURL = try? FolderBookmark.getPersistentFileURL(bookmark) else {
            return nil
        }
        return persistentURL
    }

    /// Get the sandbox bookmark
    /// - Parameter bookmark: The name of the bookmark
    /// - Returns: The URL of the bookmark
    public static func getPersistentFileURL(_ bookmark: String) throws -> URL? {
        guard let bookmarkData = UserDefaults.standard.data(forKey: bookmark) else {
            throw BookmarkError.notFound
        }
        do {
            var bookmarkDataIsStale = false
#if os(macOS)
            let urlForBookmark = try URL(
                resolvingBookmarkData: bookmarkData,
                relativeTo: nil,
                bookmarkDataIsStale: &bookmarkDataIsStale
            )
#else
            let urlForBookmark = try URL(
                resolvingBookmarkData: bookmarkData,
                relativeTo: nil,
                bookmarkDataIsStale: &bookmarkDataIsStale
            )
#endif
            if bookmarkDataIsStale {
                _ = setPersistentFileURL(bookmark, urlForBookmark)
            }
            return urlForBookmark
        } catch {
            throw error
        }
    }
}

// MARK: Private functions

private extension FolderBookmark {

    /// Set the sandbox bookmark
    /// - Parameters:
    ///   - bookmark: The name of the bookmark
    ///   - selectedURL: The URL of the bookmark
    /// - Returns: True or false if the bookmark is set
    static func setPersistentFileURL(_ bookmark: String, _ selectedURL: URL) -> Bool {
        do {
            _ = selectedURL.startAccessingSecurityScopedResource()
#if os(macOS)
            let bookmarkData = try selectedURL.bookmarkData(
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
#else
            let bookmarkData = try selectedURL.bookmarkData(
                options: .suitableForBookmarkFile,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
#endif
            UserDefaults.standard.set(bookmarkData, forKey: bookmark)
            selectedURL.stopAccessingSecurityScopedResource()
            return true
        } catch let error {
            print(error.localizedDescription)
            selectedURL.stopAccessingSecurityScopedResource()
            return false
        }
    }

    /// Get the Documents directory
    /// - Returns: The users Documents directory
    static func getDocumentsDirectory() -> URL {
        // swiftlint:disable:next force_unwrapping
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
