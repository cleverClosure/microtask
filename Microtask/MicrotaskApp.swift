//
//  MicrotaskApp.swift
//  Microtask
//
//  Created by Tim Isaev on 06.11.2025.
//

import SwiftUI

@main
struct MicrotaskApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarController: MenuBarController?
    var appState: AppState?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide from Dock
        NSApp.setActivationPolicy(.accessory)

        // Initialize app state
        appState = AppState()

        // Setup menu bar
        menuBarController = MenuBarController()

        // Create the SwiftUI content view
        let contentView = MainContentView()
            .environmentObject(appState!)

        // Wrap in NSHostingController
        let hostingController = NSHostingController(rootView: contentView)
        menuBarController?.setPopoverContent(hostingController)
    }
}
