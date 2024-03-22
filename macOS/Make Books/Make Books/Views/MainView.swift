//
//  MainView.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

/// SwiftUI `View` for the main content
struct MainView: View {
    /// The state of the Scene
    @Environment(SceneState.self) private var scene
    /// The state of the Library
    @Environment(Library.self) private var library
    /// The state of Make
    @Environment(MakeState.self) private var make
    /// The visibility of the splitview
    @State private var navigationSplitViewVisibility: NavigationSplitViewVisibility = .all

    @Environment(\.openWindow) var openWindow

    /// The body of the `View`
    var body: some View {
        @Bindable var scene = scene
        NavigationSplitView(
            columnVisibility: $navigationSplitViewVisibility,
            sidebar: {
                SidebarView()
                    .toolbar(removing: .sidebarToggle)
                    .navigationSplitViewColumnWidth(200)
            },
            detail: {
                NavigationStack(path: $scene.navigationStack) {
                    Router.DestinationView(router: scene.mainSelection)
                        .navigationDestination(for: Router.self) { router in
                            Router.DestinationView(router: router)
                                .navigationTitle(router.item.title)
                                .opacity(scene.navigationStack.last == router ? 1 : 0)
                                .background(Color.windowBackground)
                        }
                        .opacity(scene.navigationStack.isEmpty ? 1 : 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.windowBackground)
            }
        )
        .searchable(text: $scene.searchQuery, placement: .automatic, prompt: "Search for books")
        .inspector(isPresented: .constant(true)) {
            InspectorView()
                .inspectorColumnWidth(280)
        }
        .toolbar(id: "Toolbar") {
            ToolbarItem(
                id: "booksFolder",
                placement: .primaryAction,
                showsByDefault: true
            ) {
                Buttons.BooksFolderButton()
            }
            ToolbarItem(
                id: "exportFolder",
                placement: .primaryAction,
                showsByDefault: true
            ) {
                Buttons.ExportFolderButton()
            }
            ToolbarItem(
                id: "preview",
                placement: .automatic,
                showsByDefault: true
            ) {
                Button {
                    openWindow(id: "preview")
                } label: {
                    Label("Preview", systemImage: scene.showInspector ? "eye.fill" : "eye")
                }
            }
        }
        .fileDropper()
        .navigationTitle("Make Books")
        .navigationSubtitle(scene.detailSelection.item.description)
        .onChange(of: scene.navigationStack) { _, item in
            scene.detailSelection = (item.isEmpty ? scene.mainSelection : item.last) ?? scene.mainSelection
        }
        .onChange(of: scene.searchQuery) {
            scene.mainSelection = scene.searchQuery.isEmpty ? .books : .search
            scene.navigationStack = []
        }
    }
}
