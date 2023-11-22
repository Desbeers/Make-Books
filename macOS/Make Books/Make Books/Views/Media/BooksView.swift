//
//  BooksView.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

/// SwiftUI `View` for Books
struct BooksView: View {
    /// The Books to show
    let books: [Book]
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    /// The state of the Library
    @Environment(Library.self) private var library
    /// The state of the sorting
    @State private var sorting: Sort = Sort()
    /// The Books sorted into a collection
    @State private var collection: ScrollCollection<Book> = []
    /// Bool to show the books in a grid or list
    @AppStorage(UserSetting.collectionDisplayMode.rawValue) var showAsList: Bool = false
    /// The body of the `View`
    var body: some View {
        VStack {
            HStack {
                Button(
                    action: {
                        showAsList.toggle()
                    }, label: {
                        Label("List Style", systemImage: showAsList ? "list.bullet" : "square.grid.2x2")
                    }
                )
                .labelStyle(.iconOnly)
                BookListSort.PickerView(sorting: $sorting)
            }
            .padding(.top)
            .padding(.horizontal)
            ScrollCollectionView(
                collection: collection,
                style: showAsList ? .asList : .asGrid,
                anchor: .top,
                header: { header in
                    Header(header: header)
                },
                cell: { index, book in
                    Cell(book: book)
                        .background(
                            Color.alternatedList.opacity(showAsList ? index % 2 == 1 ? 1 : 0 : 0)
                        )
                }
            )
        }
        .animation(.default, value: sorting)
        .animation(.default, value: showAsList)
        .task(id: books) {
            sorting = library.getSortSetting(router: scene.detailSelection)
            collection = groupBooks(sorting: sorting)
        }
        .onChange(of: sorting) { _, newSort in
            collection = groupBooks(sorting: newSort)
        }
        .navigationSubtitle(scene.mainSelection.item.title)
    }

    private func groupBooks(sorting: Sort) -> ScrollCollection<Book> {
        let bookList = books.sorted(sortItem: sorting)
        switch sorting.method {
        case .title:
            return Dictionary(grouping: bookList) { book in
                ScrollCollectionHeader(
                    sectionLabel: String(book.sortTitle.prefix(1).uppercased()),
                    indexLabel: String(book.sortTitle.prefix(1).uppercased()),
                    sort: String(book.sortTitle.prefix(1).uppercased())
                )
            }
            .sorted(using: KeyPathComparator(\.key.sort))
        case .author:
            return Dictionary(grouping: bookList) { book in
                ScrollCollectionHeader(
                    sectionLabel: book.author,
                    indexLabel: String(book.sortAuthor.prefix(1).uppercased()),
                    sort: book.sortAuthor
                )
            }
            .sorted(using: [
                KeyPathComparator(\.key.sort),
                KeyPathComparator(\.key.sectionLabel)
            ])
        case .date:
            return Dictionary(grouping: bookList) { book in
                var sectionLabel = "Unknown"
                var indexLabel = "Unknown"
                if let year = Int(book.date?.prefix(4) ?? "") {
                    let decade = (year / 10) * 10
                    sectionLabel = "Between \(decade) and \(decade + 9)"
                    indexLabel = String(decade)
                }
                return ScrollCollectionHeader(
                    sectionLabel: sectionLabel,
                    indexLabel: indexLabel,
                    sort: indexLabel
                )
            }
            .sorted(using: KeyPathComparator(\.key.sort))
        case .hasBeenReed:
            return Dictionary(grouping: bookList) { book in
                let section = book.hasBeenRead ?? false ? "􀆅 Read" : "􀋂 New Books"
                return ScrollCollectionHeader(
                    sectionLabel: section,
                    indexLabel: String(section.prefix(1)),
                    sort: section
                )
            }
            .sorted(using: KeyPathComparator(\.key.sort, order: sorting.order == .ascending ? .reverse : .forward))
        }
    }
}
