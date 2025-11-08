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
    @State private var showingTabTypePopover = false

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
                    },
                    onDelete: {
                        appState.deleteTab(tab.id)
                    }
                )
            }

            // Plus button to add new tabs - newspaper style with popover
            Button(action: {
                showingTabTypePopover.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .strokeBorder(Color.black.opacity(0.2), lineWidth: 0.5)
                        )

                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color.black.opacity(0.7))
                }
                .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showingTabTypePopover) {
                VStack(spacing: 0) {
                    Button(action: {
                        let newTabId = appState.createTab(type: .note)
                        if let newTab = appState.tabs.first(where: { $0.id == newTabId }) {
                            editingName = newTab.name
                            editingTabId = newTabId
                        }
                        showingTabTypePopover = false
                    }) {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Note Tab")
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(width: 120)
                    }
                    .buttonStyle(.plain)

                    Divider()

                    Button(action: {
                        let newTabId = appState.createTab(type: .task)
                        if let newTab = appState.tabs.first(where: { $0.id == newTabId }) {
                            editingName = newTab.name
                            editingTabId = newTabId
                        }
                        showingTabTypePopover = false
                    }) {
                        HStack {
                            Image(systemName: "checklist")
                            Text("Task Tab")
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(width: 120)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 4)
            }
            .help("Add new tab")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(red: 0.98, green: 0.97, blue: 0.95))
    }
}
