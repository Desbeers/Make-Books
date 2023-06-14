//  DropView.swift
//  Make books
//
//  © 2023 Nick Berendsen

import SwiftUI

/// SwiftUI View for the Markdown drop
struct DropView: View {
    @State var isDrop: Bool = false
    @State var isRunning: Bool = false
    @State var fileURL: URL?
    @Environment(\.presentationMode) var presentationMode
    /// The body of the View
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.accentColor)
                        .font(.title)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                Text("Make a PDF").font(.largeTitle)
                Spacer()
            }
            Text("Still writing? Drop your Markdown file here and make a PDF from it. It will be saved on your Desktop for proofreading.")
                .padding()
            Spacer()
            Text("Drop a Markdown file").font(.title3)
            ZStack {
                Image(systemName: "tray.and.arrow.down")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(fileURL?.pathExtension == "md" ? .accentColor : .secondary)
                    .opacity(isRunning ? 0.1 : 1 )
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(
                        style: StrokeStyle(
                            lineWidth: 4,
                            dash: [4]
                        )
                    )
                    .foregroundColor(isDrop ? .red : .secondary)
                    .frame(width: 160, height: 160)
                if isRunning {
                    ProgressView()
                }
            }
            if fileURL != nil {
                Text(fileURL?.pathExtension == "md" ? fileURL!.lastPathComponent : "Your drop was not a markdown file")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Button {
                isRunning = true
                let script = Bundle.main.url(forResource: BookType.makePDF.rawValue, withExtension: nil)
                let makePdf = Process()
                makePdf.executableURL = URL(fileURLWithPath: "/bin/zsh")
                makePdf.arguments = [
                    "--login", "-c", "'\(script!.path)' '" + fileURL!.path + "'"
                ]
                makePdf.terminationHandler = { _ in
                    Task { @MainActor in
                        isRunning = false
                    }
                }
                do {
                    try makePdf.run()
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            } label: {
                Text(" Make PDF")
            }
            .disabled(fileURL == nil || fileURL?.pathExtension != "md" || isRunning)
            Spacer()
        }
        .onDrop(of: ["public.file-url"], delegate: self)
        .padding()
        .frame(width: 350, height: 420)
    }
}

//// The 'drop handler' for DropView
extension DropView: DropDelegate {
    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: ["public.file-url"])
    }
    func dropEntered(info: DropInfo) {
        self.isDrop = true
    }
    func dropExited(info: DropInfo) {
        self.isDrop = false
    }
    func performDrop(info: DropInfo) -> Bool {
        NSSound(named: "Submarine")?.play()
        if let item = info.itemProviders(for: ["public.file-url"]).first {
            item.loadItem(forTypeIdentifier: "public.file-url", options: nil) { urlData, _ in
                DispatchQueue.main.async {
                    if let urlData = urlData as? Data {
                        fileURL = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                    }
                }
            }
            return true
        } else {
            return false
        }
    }
}
