//
//  SidebarView.swift
//  Make Books
//
//  Created by Nick Berendsen on 17/07/2023.
//

import SwiftUI

/// SwiftUI View for the sidebar
struct SidebarView: View {
    /// The state of the Scene
    @EnvironmentObject private var scene: SceneState
    /// The body of the `View`
    var body: some View {
        List(selection: $scene.mainSelection) {
            Section("My Books") {
                ForEach(Router.main, id: \.self) { item in
                    Label(item.item.title, systemImage: item.item.icon)
                }
            }
            Section("Create") {
                ForEach(Router.create, id: \.self) { item in
                    Label(item.item.title, systemImage: item.item.icon)
                }
            }
            if !scene.searchQuery.isEmpty {
                Section("Search") {
                    Label(Router.search.item.title, systemImage: Router.search.item.icon)
                        .tag(Router.search)
                }
            }
        }
        .onChange(of: scene.mainSelection) {
            scene.detailSelection = scene.mainSelection
            scene.previewURL = nil
        }
//        Router.DestinationView(router: scene.mainSelection)
//            .navigationDestination(for: Router.self) { router in
//                Router.DestinationView(router: router)
//                    .navigationTitle(router.item.title)
//                    .navigationSubtitle(router.item.title)
//                    .opacity(scene.navigationStack.last == router ? 1 : 0)
//                    .modifier(ToolbarView())
//            }
//            .opacity(scene.navigationStack.isEmpty ? 1 : 0)
//            .modifier(ToolbarView())
    }
}
