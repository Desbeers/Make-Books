//
//  SceneState.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

/// The class with the Scene state
@Observable final class SceneState {

    // MARK: Navigation

    /// The main selection from the sidebar
    var mainSelection: Router = .books
    /// The Navigation stack of the router
    var navigationStack: [Router] = []
    /// The detail selection
    var detailSelection: Router = .books
//    /// The sidebar selection
//    var sidebarSelection: Router {
//        if let stack = navigationStack.last {
//            return stack
//        }
//        return mainSelection
//    }

    var showInspector: Bool = false

    // MARK: Dropped URL

    /// The optional dropped URL
    var droppedURL: URL?
    /// Bool if the dropping is in progress
    var isDropping = false

    // MARK: Sheets

    /// Show sheet with Make
    var makeBooksSheet: Bool = false
//    /// Show sheet to edit a book
//    @Published var editBook: Book?
    /// Show preview in the inspector
    var previewURL: PreviewURL?

    // MARK: Search

    /// The search query
    var searchQuery: String = ""}

extension SceneState {

    /// The struct for a URL preview
    struct PreviewURL: Identifiable, Equatable {
        /// The ID of the URL pereview
        var id: UUID = UUID()
        /// The URL pereview
        var url: URL
    }
}

extension SceneState {

//    func goBack(book: Book? = nil) {
//        dump(navigationStack.map {$0.item.description})
//        if navigationStack.isEmpty {
//            if let book {
//                navigationStack.append(.book(book: book))
//            } else {
//                mainSelection = .books
//            }
//        } else {
//            navigationStack.removeLast()
//            /// Replace last item in the stack with the updated book
//            if let book {
//                switch book.media {
//                case .book:
//                    navigationStack.append(.book(book: book))
//                case .tag:
//                    navigationStack.append(library.getCollectionLink(collection: book))
//                case .collection:
//
//                default:
//                    break
//                }
//            }
//
//        }
//    }

}

/// The `FocusedValueKey` for the scene state
struct SceneFocusedValueKey: FocusedValueKey {
    /// The `typealias` for the key
    typealias Value = Binding<SceneState>
}

extension FocusedValues {
    /// The value of the scene state key
    var scene: SceneFocusedValueKey.Value? {
        get {
            self[SceneFocusedValueKey.self]
        }
        set {
            self[SceneFocusedValueKey.self] = newValue
        }
    }
}
