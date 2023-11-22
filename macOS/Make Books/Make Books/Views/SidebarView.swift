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
    @Environment(SceneState.self) private var scene
    /// The body of the `View`
    var body: some View {
        @Bindable var scene = scene
        List(selection: $scene.mainSelection) {
            Section("My Books") {
                ForEach(Router.main, id: \.self) { item in
                    Label(item.item.title, systemImage: item.item.icon)
                }
            }
            Section("Create") {
                ForEach(Router.create, id: \.self) { item in
                    Label(item.item.title, systemImage: item.item.icon)
                        .tint(item.item.color)
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
    }
}
