//
//  PartsView.swift
//  Make Books
//
//  Created by Nick Berendsen on 19/11/2023.
//

import SwiftUI

enum PartsView {
    // Just a placeholder
}

extension PartsView {

    struct NoContentView: View {
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        var body: some View {
            ContentUnavailableView(
                scene.detailSelection.item.description,
                systemImage: scene.detailSelection.item.icon,
                description: Text(scene.detailSelection.item.empty)
            )
        }
    }
}
