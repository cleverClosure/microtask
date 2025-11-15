//
//  TabBarView.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var appState: AppState
    @State private var editingName: String = ""

    var body: some View {
        HStack(spacing: 6) {
            ForEach(appState.tabs) { tab in
                TabItemView(
                    tab: tab,
                    isActive: tab.id == appState.activeTabId,
                    isEditing: Binding(
                        get: { appState.editingTabId == tab.id },
                        set: { if !$0 { appState.editingTabId = nil } }
                    ),
                    editingName: $editingName,
                    onSelect: {
                        // Just switch tabs - TabItemView's onChange(of: isActive) will handle saving
                        appState.activeTabId = tab.id
                    },
                    onNameChange: { newName in
                        appState.updateTabName(tab.id, name: newName)
                        appState.editingTabId = nil
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(red: 0.98, green: 0.97, blue: 0.95))
    }
}
