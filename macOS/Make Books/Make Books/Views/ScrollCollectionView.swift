//
//  ScrollCollectionView.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI

// MARK: ScrollCollection

/// Alias for the grouped collection dictonary
public typealias ScrollCollection<Element: Identifiable> = [(ScrollCollectionHeader, [Element])]

/// Struct for the label and index for a header in the collection
public struct ScrollCollectionHeader: Hashable {
    public init(sectionLabel: String, indexLabel: String, sort: String) {
        self.sectionLabel = sectionLabel
        self.indexLabel = indexLabel
        self.sort = sort
    }

    /// The label of the section
    public let sectionLabel: String
    /// The label for the index
    public let indexLabel: String
    /// The sorting
    public let sort: String
}

/// Enum to represent different display styles for the collection
public enum ScrollCollectionStyle {
    /// View as list
    case asList
    /// Vies as grid
    case asGrid
    /// View as plain (no sections and index)
    case asPlain
}

// MARK: ScrollCollectionView

public struct ScrollCollectionView<Element: Identifiable, HeaderView: View, CellView: View>: View {

    // MARK: Properties

    /// The collection of sorted elements
    let collection: ScrollCollection<Element>
    /// Display style for the collection (List or Grid)
    let style: ScrollCollectionStyle
    /// The anchor point for scrolling to the selected letter
    let anchor: UnitPoint
    /// The Grid
    let grid: [GridItem]
    /// The header view for each element in the collection
    let header: (ScrollCollectionHeader) -> HeaderView
    /// The cell view for each element in the collection
    let cell: (Int, Element) -> CellView
    /// State to store the selected letter from the section index
    @State private var selectedLetter = ""
    /// Extract the headers from the collection by the unique index label
    let headers: [ScrollCollectionHeader]
    /// Pinned Views in the grid
    let pinnedViews: PinnedScrollableViews

    // MARK: Init

    /// Initialization of SectionScrollView
    public init(
        collection: ScrollCollection<Element>,
        style: ScrollCollectionStyle,
        anchor: UnitPoint,
        pinnedViews: PinnedScrollableViews = [.sectionHeaders],
        grid: [GridItem] = [GridItem(.adaptive(minimum: 140))],
        showIndex: Bool = true,
        @ViewBuilder header: @escaping (ScrollCollectionHeader) -> HeaderView,
        @ViewBuilder cell: @escaping (Int, Element) -> CellView
    ) {
        self.style = style
        self.collection = collection
        self.cell = cell
        self.anchor = anchor
        self.header = header
        self.grid = grid
        self.pinnedViews = pinnedViews
        if showIndex {
            let headers = collection.map(\.0).uniqued(by: \.indexLabel)
            self.headers = ( headers.count > 1 ) ? headers : []
        } else {
            self.headers = []
        }
    }

    // MARK: Body of the View

    /// The body of the `View`
    public var body: some View {
        ScrollViewReader { pageScroller in
            ScrollView {
                switch style {
                case .asList:
                    LazyVStack(alignment: .center, spacing: 0, pinnedViews: pinnedViews) {
                        content
                    }
                case .asGrid:
                    LazyVGrid(columns: grid, alignment: .center, spacing: 0, pinnedViews: pinnedViews) {
                        content
                    }
                case .asPlain:
                    LazyVStack(alignment: .center, spacing: 0) {
                        ForEach(collection, id: \.0) { _, elements in
                            ForEach(elements) { element in
                                cell(1, element)
                            }
                        }
                    }
                }
            }
#if !os(tvOS)
            .overlay {
                if !headers.isEmpty {
                    HStack {
                        Spacer()
                        ScrollCollectionIndex(
                            headers: headers,
                            selectedLetter: $selectedLetter,
                            pageScroller: pageScroller,
                            anchor: anchor
                        )
                    }
                }
            }
#endif
            .id(collection.map(\.0))
        }
    }

    // MARK: Content of the View

    /// The body of the `View`
    public var content: some View {
        ForEach(collection, id: \.0) { section, elements in
            Section(
                content: {
                    ForEach(Array(zip(elements.indices, elements)), id: \.0) { index, element in
                        cell(index, element)
                            .id(element.id)
                    }
                }, header: {
                    header(section)
                        .id(section.sectionLabel)
                }
            )
        }
    }
}

#if !os(tvOS)

// MARK: ScrollCollectionView Index

/// SwiftUI `View` with the index for the sections
struct ScrollCollectionIndex: View {

    // MARK: Properties

    /// The array containing the section headers to be displayed
    let headers: [ScrollCollectionHeader]
    /// The selected letter that the ScrollViewProxy will scroll to
    @Binding var selectedLetter: String
    /// The ScrollViewProxy used to scroll to the selected letter
    let pageScroller: ScrollViewProxy
    /// The anchor point for scrolling to the selected letter
    let anchor: UnitPoint
    /// The current drag location for gesture tracking
    @GestureState private var dragLocation: CGPoint = .zero

    // MARK: Body of the View

    /// The body of the `View`
    var body: some View {
        VStack {
            ForEach(headers, id: \.self) { header in
                Text(header.indexLabel)
                    .font(.headline)
                /// Background modifier for tracking gestures
                    .background(dragObserver(title: header.sectionLabel, anchor: anchor))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location // Update the dragLocation with the current gesture location.
                }
        )
        .padding(3)
        .background(.thickMaterial)
        .cornerRadius(3)
    }

    // MARK: Methods

    // Method to add a GeometryReader for drag gesture tracking.
    private func dragObserver(title: String, anchor: UnitPoint) -> some View {
        GeometryReader { geometry in
            dragObserver(geometry: geometry, title: title, anchor: anchor)
        }
    }

    // Method to handle the drag gesture and scrolling to the selected letter.
    private func dragObserver(geometry: GeometryProxy, title: String, anchor: UnitPoint) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            Task {
                /// Scroll to the selected letter in the ScrollViewProxy
                withAnimation {
                    pageScroller.scrollTo(title, anchor: anchor)
                }
                /// Update the selectedLetter binding with the current letter
                selectedLetter = title
            }
        }
        /// Invisible filler rectangle
        return Rectangle().fill(Color(.white).opacity(0.001))
    }
}
#endif

// MARK: Sequence extension

public extension Sequence {

    /// Filter a Sequence by an unique keypath
    /// - Parameter keyPath: The keypath
    /// - Returns: The unique Sequence
    func uniqued<Type: Hashable>(by keyPath: KeyPath<Element, Type>) -> [Element] {
        var set = Set<Type>()
        return filter { set.insert($0[keyPath: keyPath]).inserted }
    }
}
