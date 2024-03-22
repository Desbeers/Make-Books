//
//  BookView+Header.swift
//  Make Books
//
//  Created by Nick Berendsen on 22/03/2024.
//

import SwiftUI

extension BookView {
    struct Header: View {
        /// The state of the Scene
        @Environment(SceneState.self) private var scene
        var body: some View {
            VStack {
                Text(.init(scene.detailSelection.item.title))
                    .font(.largeTitle)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 40)
                Text(.init(scene.detailSelection.item.description))
                    .font(.title3)
            }
            .padding(.horizontal, 60)
            .padding()
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Image(systemName: scene.detailSelection.item.icon)
                    .font(.system(size: 40))
                    .padding(.leading)
            }
            .background(.thinMaterial)
            .cornerRadius(StaticSetting.cornerRadius)
            .padding([.top, .horizontal])
        }
    }
}
