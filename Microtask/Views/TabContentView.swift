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
            // List of rows
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(tab.rows) { row in
                        TextRowView(row: row, tabId: tab.id)
                    }
                }
                .padding(.vertical, 8)
            }

            Divider()

            // Input field for new tasks
            HStack(spacing: 8) {
                TextField("Add new task...", text: $newTaskText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13))
                    .focused($isInputFocused)
                    .onSubmit {
                        addNewTask()
                    }

                if !newTaskText.isEmpty {
                    Button(action: addNewTask) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(12)
            .background(Color(nsColor: .controlBackgroundColor))
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
