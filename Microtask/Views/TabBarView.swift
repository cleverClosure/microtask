//
//  TabBarView.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var appState: AppState
    @State private var editingTabId: UUID?
    @State private var editingName: String = ""

    var body: some View {
        HStack(spacing: 4) {
            ForEach(appState.tabs) { tab in
                TabItemView(
                    tab: tab,
                    isActive: tab.id == appState.activeTabId,
                    isEditing: Binding(
                        get: { editingTabId == tab.id },
                        set: { if !$0 { editingTabId = nil } }
                    ),
                    editingName: $editingName,
                    onSelect: {
                        appState.activeTabId = tab.id
                        appState.collapseAllRows(in: tab.id)
                    },
                    onNameChange: { newName in
                        appState.updateTabName(tab.id, name: newName)
                        editingTabId = nil
                    }
                )
            }

            // Plus button to add new tabs
            Button(action: {
                appState.createTab()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(nsColor: .controlBackgroundColor))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .help("Add new tab")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
