// https://forums.developer.apple.com/thread/125183

import SwiftUI
import AppKit

struct BlurryBackground: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = .appearanceBased
        nsView.blendingMode = .behindWindow
        nsView.state = .followsWindowActiveState
    }
}
  
extension View {
    func blurryBackground() -> some View {
        background(
            BlurryBackground()
        )
    }
}
