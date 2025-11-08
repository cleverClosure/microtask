//
//  MainContentView.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Tab bar at the top
            TabBarView()

            Divider()

            // Content area for active tab
            if let activeTab = appState.activeTab {
                TabContentView(tab: activeTab)
            } else {
                emptyStateView
            }
        }
        .frame(width: 340, height: 480)
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear {
            setupKeyboardShortcuts()
        }
    }

    private func setupKeyboardShortcuts() {
        // ESC key handling is done via NSPopover's transient behavior
        // Additional shortcuts can be added here if needed
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "checklist")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No tabs")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)

            Text("Click the + button to create your first tab")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
