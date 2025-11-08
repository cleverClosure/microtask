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
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(row.isExpanded ? Color(nsColor: .controlBackgroundColor) : Color.clear)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
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
            } else {
                saveChanges()
            }
        }
    }

    private var collapsedView: some View {
        Text(row.content.isEmpty ? "Empty task..." : row.content)
            .font(.system(size: 13))
            .foregroundColor(row.content.isEmpty ? .secondary : .primary)
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var expandedView: some View {
        TextEditor(text: $editingText)
            .font(.system(size: 13))
            .focused($isFocused)
            .frame(minHeight: 60, maxHeight: 200)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .onChange(of: editingText) { _, _ in
                saveChanges()
            }
    }

    private func saveChanges() {
        if editingText != row.content {
            appState.updateRow(in: tabId, rowId: row.id, content: editingText)
        }
    }
}
