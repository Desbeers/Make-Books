//
//  MakeCover.swift
//  Make Books
//
//  Created by Nick Berendsen on 04/09/2023.
//

import SwiftUI

enum BookCover {
    // Just a namespace
}

extension BookCover {

    /// SwiftUI `View` for a book cover
    struct Cover: View {
        /// The ``Book``
        let book: Book
        /// The body of the `View`
        var body: some View {
            getCover(book: book)
                .resizable()
        }
    }

    /// Get the cover of a book
    /// - Parameter cover: The cover URL
    /// - Returns: An NSImage with the cover
    @MainActor static func getCover(book: Book) -> Image {
        guard
            let cover = book.coverURL,
                let imageData = try? Data(contentsOf: cover),
                let image = NSImage(data: imageData)
        else {
            /// This should not happen
            return BookCover.createFallback(book: book)
        }
        return Image(nsImage: image)
    }

    @MainActor static func saveFallbackCover(book: Book) throws {
        let coverURL = book.assetsURL.appendingPathComponent("cover-screen.jpg")
        guard
            let cover = ImageRenderer(content: BookCover.Fallback(book: book)).nsImage,
            let data = cover.tiffRepresentation,
            let imageRep = NSBitmapImageRep(data: data),
            let jpgData = imageRep.representation(using: .jpeg, properties: [:])
        else {
            throw CoverError.unknownError
        }
        try jpgData.write(to: coverURL)
    }

    enum CoverError: LocalizedError {
        case unknownError

        public var description: String {
            switch self {
            case .unknownError:
                return "Unknown error"
            }
        }

        public var errorDescription: String? {
            return description
        }
    }

    /// Create a fallback cover image
    /// - Parameters:
    ///   - book: The ``Book``
    @MainActor static func createFallback(book: Book) -> Image {
        guard
            let fallback = ImageRenderer(content: Fallback(book: book)).cgImage
        else {
            return Image(systemName: "questionmark")
        }
        return Image(fallback, scale: 1, label: Text("Image")).resizable()
    }

    /// SwiftUI `View` for a fallback cover
    struct Fallback: View {
        /// The ``Book``
        let book: Book
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.teal.gradient)
                VStack {
                    Text(book.title)
                        .font(.system(size: 200))
                        .foregroundStyle(.primary)
                        .lineLimit(correctLineLimit)
                        .padding()
                    Text(book.author)
                        .font(.system(size: 100))
                        .foregroundStyle(.secondary)
                        .padding()
                    Image(.hugeIcon)
                        .resizable()
                        .scaledToFit()
                }
                .minimumScaleFactor(0.1)
                .multilineTextAlignment(.center)
                .allowsTightening(true)
                .padding()
            }
            .frame(width: 1000, height: 1500)
        }

        /// Calculate the line limit
        ///
        /// Make sure a 'one word' line will not be wrapped
        var correctLineLimit: Int {
            let wordcount = book.title.split(separator: " ")
            return wordcount.count > 1 ? 2 : 1
        }
    }
}
