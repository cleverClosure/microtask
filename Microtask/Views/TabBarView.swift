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
        HStack(spacing: 6) {
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
                    },
                    onNameChange: { newName in
                        appState.updateTabName(tab.id, name: newName)
                        editingTabId = nil
                    }
                )
            }

            // Plus button to add new tabs - newspaper style
            Button(action: {
                appState.createTab()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(Color.black.opacity(0.15), lineWidth: 0.5)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.white.opacity(0.5))
                        )

                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(Color.black.opacity(0.6))
                }
                .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .help("Add new tab")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(red: 0.98, green: 0.97, blue: 0.95))
    }
}
