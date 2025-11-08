//
//  MenuBarController.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import AppKit
import SwiftUI

class MenuBarController: ObservableObject {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?

    @Published var isPopoverShown = false

    init() {
        setupMenuBar()
        setupPopover()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            // Create a simple icon using SF Symbols
            if let image = NSImage(systemSymbolName: "checklist", accessibilityDescription: "Microtask") {
                image.isTemplate = true
                button.image = image
            }

            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    private func setupPopover() {
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 340, height: 480)
        popover?.behavior = .transient
        popover?.delegate = self
    }

    func setPopoverContent(_ content: NSViewController) {
        popover?.contentViewController = content
    }

    @objc func togglePopover() {
        guard let button = statusItem?.button else { return }

        if let popover = popover {
            if popover.isShown {
                popover.close()
                isPopoverShown = false
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                isPopoverShown = true

                // Make the popover window key and focused
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }

    func closePopover() {
        popover?.close()
        isPopoverShown = false
    }
}

extension MenuBarController: NSPopoverDelegate {
    func popoverDidClose(_ notification: Notification) {
        isPopoverShown = false
    }
}
