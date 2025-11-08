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
        .frame(width: 52, height: 32)
        .contentShape(Rectangle())
        .scaleEffect(isHovering && !isActive ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.08), value: isHovering)
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
                HStack(spacing: 2) {
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

            Text(tab.abbreviation)
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(tab.color.opacity(0.9))
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
