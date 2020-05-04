//
//  AppDelegate.swift
//  Make books
//
//  Created by Nick Berendsen on 25/12/2019.
//  Copyright © 2020 Nick Berendsen. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    // https://troz.net/post/2019/swiftui-for-mac-2/
    @IBOutlet weak var darkModeMenuItem: NSMenuItem!
    @IBOutlet weak var lightModeMenuItem: NSMenuItem!
    @IBOutlet weak var systemModeMenuItem: NSMenuItem!
    // Settings that should be saved
    
    @UserDefault("system_mode", defaultValue: "dark") var systemMode: String

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setStoredSystemMode()


        
        /// Create the SwiftUI view that provides the window contents.
        let mainView = ContentView()
            /// Get the books object
            .environmentObject(Books())
            /// Set the minimum size of the window
            .frame(minWidth: 480, maxWidth: .infinity, minHeight: 570, maxHeight: .infinity)
        /// Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 570),
            styleMask: [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        /// This apllication has no tabbing
        window.tabbingMode = .disallowed
        window.title = "Make books"
        window.center()
        window.setFrameAutosaveName("Main Window")

        //window?.contentView?.wantsLayer = true
        window.contentView = NSHostingView(rootView: mainView)
        //window?.contentView?.layer?.contents = NSImage(named: NSImage.Name("MainBackground"))
        
        //window.titlebarAppearsTransparent = true

        
        /// Set this window front and center
        window.makeKeyAndOrderFront(nil)
        
        /// Switch to dark mode when going full screen
        NotificationCenter.default.addObserver(forName: NSWindow.willEnterFullScreenNotification,
                                               object: nil, queue: OperationQueue.main, using: { note in
            NSApp.appearance = NSAppearance(named: .darkAqua)
            print("Entered Fullscreen")
        })
        // Go back to default when exiting full screen
        NotificationCenter.default.addObserver(forName: NSWindow.willExitFullScreenNotification,
                                               object: nil, queue: OperationQueue.main, using: { note in
            self.setStoredSystemMode()
            print("Exited Fullscreen")
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        /// Quit the application when we close the window
        return true
    }

    func setStoredSystemMode() {
        switch systemMode {
        case "dark":
            NSApp.appearance = NSAppearance(named: .darkAqua)
        case "light":
            NSApp.appearance = NSAppearance(named: .aqua)
        default:
            NSApp.appearance = nil
        }
        showSelectedModeInMenu()
    }
    
    func showSelectedModeInMenu() {
        switch systemMode {
        case "dark":
            darkModeMenuItem.state = .on
            lightModeMenuItem.state = .off
            systemModeMenuItem.state = .off
        case "light":
            darkModeMenuItem.state = .off
            lightModeMenuItem.state = .on
            systemModeMenuItem.state = .off
        default:
            darkModeMenuItem.state = .off
            lightModeMenuItem.state = .off
            systemModeMenuItem.state = .on
        }
    }
    
    @IBAction func darkModeSelected(_ sender: Any) {
        NSApp.appearance = NSAppearance(named: .darkAqua)
        systemMode = "dark"
        showSelectedModeInMenu()
    }
    
    @IBAction func lightModeSelected(_ sender: Any) {
        NSApp.appearance = NSAppearance(named: .aqua)
        systemMode = "light"
        showSelectedModeInMenu()
    }
    
    @IBAction func systemModeSelected(_ sender: Any) {
        NSApp.appearance = nil
        systemMode = "system"
        showSelectedModeInMenu()
    }
    
    @IBAction func openPrefs(_ sender: Any) {
        NotificationCenter.default.post(name: .showPrefs, object: nil)
    }

    @IBAction func showLog(_ sender: Any) {
        NotificationCenter.default.post(name: .showLog, object: nil)
    }
    
}

extension Notification.Name {
    static let showPrefs = Notification.Name("show_prefs")
    static let showLog = Notification.Name("show_log")
}
