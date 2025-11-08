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

            // Elegant thin divider
            Rectangle()
                .fill(Color.black.opacity(0.12))
                .frame(height: 0.5)

            // Content area for active tab
            if let activeTab = appState.activeTab {
                TabContentView(tab: activeTab)
                    .id(activeTab.id)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.1), value: appState.activeTabId)
            } else {
                emptyStateView
            }
        }
        .frame(width: 340, height: 480)
        .background(
            Color(red: 0.98, green: 0.97, blue: 0.95) // Newspaper cream/off-white
        )
        .onAppear {
            setupKeyboardShortcuts()
        }
    }

    private func setupKeyboardShortcuts() {
        // ESC key handling is done via NSPopover's transient behavior
        // Additional shortcuts can be added here if needed
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "text.book.closed")
                .font(.system(size: 56, weight: .thin))
                .foregroundColor(Color.black.opacity(0.25))

            VStack(spacing: 8) {
                Text("NO TABS")
                    .font(.system(size: 11, weight: .medium, design: .default))
                    .tracking(2.0)
                    .foregroundColor(Color.black.opacity(0.4))

                Text("Click the + button to begin")
                    .font(.system(size: 13, weight: .regular, design: .serif))
                    .foregroundColor(Color.black.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
