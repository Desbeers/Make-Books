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
        let style: ScrollCollectionStyle
        var body: some View {

            switch style {
            case .asList:
                VStack {
                    Text(header.sectionLabel)
                        .font(.headline)
                        .padding([.top, .leading])
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                }
                .background(.regularMaterial)
            default:
                Text(header.sectionLabel)
                    .font(.headline)
                    .padding(.horizontal)
                    .frame(
                        width: StaticSetting.coverSize.width,
                        height: StaticSetting.coverSize.height
                    )
                    .background(.regularMaterial)
                    .cornerRadius(StaticSetting.cornerRadius)
                    .padding()
            }
        }
    }
}
