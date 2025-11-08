//
//  TextRowView.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import SwiftUI

struct TextRowView: View {
    let row: TextRow
    let tabId: UUID
    @EnvironmentObject var appState: AppState
    @FocusState private var isFocused: Bool

    @State private var editingText: String
    @State private var isHovering = false

    init(row: TextRow, tabId: UUID) {
        self.row = row
        self.tabId = tabId
        _editingText = State(initialValue: row.content)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if row.isExpanded {
                expandedView
            } else {
                collapsedView
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 1)
                .fill(
                    row.isExpanded
                        ? Color.white.opacity(0.6)
                        : (isHovering ? Color.white.opacity(0.3) : Color.clear)
                )
        )
        .overlay(
            VStack {
                Spacer()
                if !row.isExpanded {
                    Rectangle()
                        .fill(Color.black.opacity(isHovering ? 0.1 : 0.06))
                        .frame(height: 0.5)
                }
            }
        )
        .contentShape(Rectangle())
        .animation(.easeInOut(duration: 0.15), value: isHovering)
        .onHover { hovering in
            if !row.isExpanded {
                isHovering = hovering
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.25)) {
                appState.toggleRowExpansion(in: tabId, rowId: row.id)
            }
            if !row.isExpanded {
                isFocused = true
            }
        }
        .onChange(of: row.isExpanded) { _, isExpanded in
            if isExpanded {
                editingText = row.content
                isFocused = true
                isHovering = false
            } else {
                saveChanges()
            }
        }
    }

    private var collapsedView: some View {
        HStack(alignment: .top, spacing: 8) {
            // Elegant bullet point
            Text("•")
                .font(.system(size: 14, weight: .light))
                .foregroundColor(Color.black.opacity(0.3))
                .frame(width: 12)

            Text(row.content.isEmpty ? "Empty task..." : row.content)
                .font(.system(size: 13, weight: .regular, design: .serif))
                .foregroundColor(row.content.isEmpty ? Color.black.opacity(0.35) : Color.black.opacity(0.85))
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var expandedView: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextEditor(text: $editingText)
                .font(.system(size: 14, weight: .regular, design: .serif))
                .foregroundColor(Color.black.opacity(0.85))
                .focused($isFocused)
                .frame(minHeight: 80, maxHeight: 220)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .lineSpacing(4)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 1)
                        .strokeBorder(Color.black.opacity(0.08), lineWidth: 0.5)
                        .background(
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.white.opacity(0.4))
                        )
                )
                .onChange(of: editingText) { _, _ in
                    saveChanges()
                }
        }
    }

    private func saveChanges() {
        if editingText != row.content {
            appState.updateRow(in: tabId, rowId: row.id, content: editingText)
        }
    }
}
