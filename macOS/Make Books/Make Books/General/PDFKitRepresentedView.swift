//
//  PDFKitRepresentedView.swift
//  Make Books
//
//  Created by Nick Berendsen on 26/07/2023.
//

import SwiftUI
import PDFKit

/// SwiftUI `NSViewRepresentable` for a PDF View
struct PDFKitRepresentedView: NSViewRepresentable {
    typealias NSViewType = PDFView
    /// The data of the View
    let data: Data
    /// Bool to show the PDF as sgingle page
    let singlePage: Bool
    /// Init the View
    init(_ data: Data, singlePage: Bool = false) {
        self.data = data
        self.singlePage = singlePage
    }

    /// Malke the View
    /// - Parameter context: The context
    /// - Returns: The PDFView
    func makeNSView(context _: NSViewRepresentableContext<PDFKitRepresentedView>) -> NSViewType {
        /// Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        if singlePage {
            pdfView.displayMode = .singlePage
        }
        return pdfView
    }

    /// Update the View
    /// - Parameters:
    ///   - pdfView: The PDGView
    ///   - context: The context
    func updateNSView(_ pdfView: NSViewType, context _: NSViewRepresentableContext<PDFKitRepresentedView>) {
        pdfView.document = PDFDocument(data: data)
    }
}
