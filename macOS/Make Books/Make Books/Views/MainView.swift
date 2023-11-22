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
    @StateObject private var make = MakeState()
    /// The visibility of the splitview
    @State private var navigationSplitViewVisibility: NavigationSplitViewVisibility = .all
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
            content: {
                NavigationStack(path: $scene.navigationStack.animation(.default)) {
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
            },
            detail: {
                DetailView()
                    .navigationSplitViewColumnWidth(300)
                    .frame(width: 300)
                    .background(Color.windowBackground)
            }
        )
        .searchable(text: $scene.searchQuery, placement: .automatic, prompt: "Search for books")
        .inspector(isPresented: $scene.showInspector) {
            PreviewView()
                .inspectorColumnWidth(min: 200, ideal: 400, max: 800)
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
                    scene.showInspector.toggle()
                } label: {
                    Label("Preview", systemImage: scene.showInspector ? "eye.fill" : "eye")
                }
            }
        }
        .fileDropper()
        .animation(.default, value: scene.detailSelection)
        .navigationTitle("Make Books")
        .navigationSubtitle(scene.detailSelection.item.description)
        .environmentObject(make)
        .task {
            await library.getAllBooks()
            await make.checkUtilities()
        }
        .onChange(of: scene.navigationStack) { _, item in
            scene.detailSelection = (item.isEmpty ? scene.mainSelection : item.last) ?? scene.mainSelection
        }
    }
}
