//
//  KodiListSort.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI Views for sorting of Books
public enum BookListSort {
    // Just a namespace here
}

public extension BookListSort {

    // MARK: PickerView

    /// Sort a list
    struct PickerView: View {
        /// The current sorting
        @Binding var sorting: Sort
        /// The state of the Library
        @Environment(Library.self) private var library
        /// Init the View
        public init(sorting: Binding<Sort>) {
            self._sorting = sorting
        }
        // MARK: Body of the View

        /// The body of the View
        public var body: some View {
            Picker(selection: $sorting, label: Text("Sort method")) {
                ForEach(Sort.Options.allCases, id: \.rawValue) { option in
                    Text(option.label)
                        .tag(Sort(id: sorting.id, method: option.sorting.method, order: option.sorting.order))
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: sorting) { _, item in
                if let index = library.listSortSettings.firstIndex(where: { $0.id == sorting.id }) {
                    library.listSortSettings[index] = item
                } else {
                    library.listSortSettings.append(item)
                }
                BookListSort.saveSortSettings(settings: library.listSortSettings)
            }
            .labelsHidden()
        }
    }
}

extension BookListSort {

    /// Get all the `List Sort` settings
    /// - Returns: The stored List Sort settings
    static func getAllSortSettings() -> [Sort] {
        if let settings = try? Cache.get(key: "ListSort", as: [Sort].self) {
            return settings
        }
        /// No settings found
        return []
    }

    /// Save the `List Sort` settings to the cache
    /// - Parameter settings: All the current List Sort settings
    static func saveSortSettings(settings: [Sort]) {
        do {
            try Cache.set(key: "ListSort", object: settings)
        } catch {
            print(error.localizedDescription)
        }
    }
}
