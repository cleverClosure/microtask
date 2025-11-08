//
//  TabItemView.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import SwiftUI

struct TabItemView: View {
    let tab: Tab
    let isActive: Bool
    @Binding var isEditing: Bool
    @Binding var editingName: String
    let onSelect: () -> Void
    let onNameChange: (String) -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            if isActive {
                // Active tab - show full name
                activeTabView
            } else {
                // Inactive tab - show abbreviation with color
                inactiveTabView
            }
        }
        .frame(width: 52, height: 32)
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            if isActive {
                startEditing()
            }
        }
        .onTapGesture(count: 1) {
            if !isEditing {
                onSelect()
            }
        }
    }

    private var activeTabView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(nsColor: .controlBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(tab.color, lineWidth: 2)
                )

            if isEditing {
                TextField("", text: $editingName)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 11, weight: .medium))
                    .focused($isFocused)
                    .onAppear {
                        isFocused = true
                    }
                    .onSubmit {
                        finishEditing()
                    }
                    .onChange(of: editingName) { _, newValue in
                        // Limit to 5 characters
                        if newValue.count > 5 {
                            editingName = String(newValue.prefix(5))
                        }
                    }
                    .padding(.horizontal, 4)
            } else {
                Text(tab.name)
                    .font(.system(size: 11, weight: .medium))
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.horizontal, 4)
            }
        }
    }

    private var inactiveTabView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(tab.color.opacity(0.8))

            Text(tab.abbreviation)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    private func startEditing() {
        editingName = tab.name
        isEditing = true
    }

    private func finishEditing() {
        let trimmed = editingName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            onNameChange(trimmed)
        }
        isEditing = false
    }
}
