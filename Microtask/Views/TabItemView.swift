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
    let onDelete: () -> Void

    @FocusState private var isFocused: Bool
    @State private var isHovering = false

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
        .frame(width: isActive ? 52 : 40, height: 32)
        .contentShape(Rectangle())
        .scaleEffect(isHovering && !isActive ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.08), value: isHovering)
        .animation(.easeInOut(duration: 0.25), value: isActive)
        .onHover { hovering in
            isHovering = hovering
        }
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
        .onChange(of: isActive) { _, newValue in
            // Save and clear focus when tab becomes inactive while editing
            if !newValue && isEditing {
                isFocused = false  // Explicitly clear focus first
                finishEditing()
            }
        }
        .onChange(of: isEditing) { _, newValue in
            // Save when editing ends
            if !newValue && !editingName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                // This handles the case where isEditing is set to false externally
                let trimmed = editingName.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed != tab.name && !trimmed.isEmpty {
                    onNameChange(trimmed)
                }
            }
        }
    }

    private var activeTabView: some View {
        ZStack {
            // Elegant newspaper tab with subtle border
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.8))
                .overlay(
                    VStack(spacing: 0) {
                        Spacer()
                        Rectangle()
                            .fill(tab.color)
                            .frame(height: 2)
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(Color.black.opacity(0.1), lineWidth: 0.5)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)

            if isEditing {
                TextField("", text: $editingName)
                    .textFieldStyle(.plain)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 10, weight: .medium, design: .default))
                    .foregroundColor(Color.black.opacity(0.85))
                    .focused($isFocused)
                    .task(id: isEditing) {
                        // Wait for SwiftUI to complete the view rendering cycle
                        if isEditing {
                            // Yield to allow the rendering pass to complete
                            await Task.yield()
                            // Additional yield to ensure TextField is fully initialized
                            await Task.yield()
                            isFocused = true
                        }
                    }
                    .onSubmit {
                        finishEditing()
                    }
                    .onChange(of: isFocused) { _, newValue in
                        // Save when focus is lost
                        if !newValue && isEditing {
                            finishEditing()
                        }
                    }
                    .onChange(of: editingName) { _, newValue in
                        // Limit to 5 characters
                        if newValue.count > 5 {
                            editingName = String(newValue.prefix(5))
                        }
                    }
                    .padding(.horizontal, 4)
            } else {
                HStack(spacing: 2) {
                    // Subtle type indicator icon
                    Image(systemName: tab.type.icon)
                        .font(.system(size: 7, weight: .medium))
                        .foregroundColor(Color.black.opacity(0.4))
                        .padding(.bottom, 3)

                    Text(tab.name.uppercased())
                        .font(.system(size: 9, weight: .semibold, design: .default))
                        .tracking(0.5)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(Color.black.opacity(0.75))
                        .padding(.bottom, 3)

                    if isHovering {
                        Button(action: {
                            onDelete()
                        }) {
                            Text("×")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color.black.opacity(0.5))
                                .frame(width: 12, height: 12)
                        }
                        .buttonStyle(.plain)
                        .padding(.bottom, 3)
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    private var inactiveTabView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .strokeBorder(tab.color.opacity(0.4), lineWidth: 0.5)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .fill(tab.color.opacity(0.08))
                )

            VStack(spacing: 1) {
                Text(tab.abbreviation)
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundColor(tab.color.opacity(0.9))

                // Subtle type indicator
                Image(systemName: tab.type.icon)
                    .font(.system(size: 5, weight: .regular))
                    .foregroundColor(tab.color.opacity(0.5))
            }
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
