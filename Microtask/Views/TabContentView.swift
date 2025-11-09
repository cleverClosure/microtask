//
//  TabContentView.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import SwiftUI

struct TabContentView: View {
    let tab: Tab
    @EnvironmentObject var appState: AppState
    @State private var newTaskText: String = ""
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // List of rows - newspaper article layout
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(tab.rows) { row in
                        TextRowView(row: row, tabId: tab.id)
                    }
                }
                .padding(.vertical, 12)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                appState.editingTabId = nil
            }

            // Elegant hairline divider
            Rectangle()
                .fill(Color.black.opacity(0.12))
                .frame(height: 0.5)

            // Input field for new tasks - newspaper style
            HStack(spacing: 10) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(Color.black.opacity(0.3))

                TextField("Add new task...", text: $newTaskText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13, weight: .regular, design: .serif))
                    .foregroundColor(Color.black.opacity(0.85))
                    .focused($isInputFocused)
                    .onSubmit {
                        addNewTask()
                    }

                if !newTaskText.isEmpty {
                    Button(action: addNewTask) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color.black.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(red: 0.98, green: 0.97, blue: 0.95))
        }
    }

    private func addNewTask() {
        let trimmed = newTaskText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        appState.addRow(to: tab.id, content: trimmed)
        newTaskText = ""
        isInputFocused = true
    }
}
