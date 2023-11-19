//
//  BooksView+Header.swift
//  Make Books
//
//  Created by Nick Berendsen on 13/08/2023.
//

import SwiftUI

extension BooksView {

    struct Header: View {
        let header: ScrollCollectionHeader
        var body: some View {
            VStack {
                Text(header.sectionLabel)
                    .font(.headline)
                    .padding([.top, .leading])
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
            }
            .background(.regularMaterial)
        }
    }
}
