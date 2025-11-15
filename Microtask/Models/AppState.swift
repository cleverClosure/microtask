//
//  AppState.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var tabs: [Tab] = []
    @Published var activeTabId: UUID?
    @Published var editingTabId: UUID?

    private let saveKey: String

    init(storageKey: String = "microtask.appstate") {
        self.saveKey = storageKey
        loadData()

        // Create predefined tabs if no tabs exist
        if tabs.isEmpty {
            createTab(name: "Notes", type: .note)
            createTab(name: "Tasks", type: .task)
            // Set the first tab (Notes) as active
            activeTabId = tabs.first?.id
        }
    }

    var activeTab: Tab? {
        guard let id = activeTabId else { return tabs.first }
        return tabs.first(where: { $0.id == id })
    }

    @discardableResult
    func createTab(name: String? = nil, type: TabType = .note) -> UUID {
        let newTabIndex = tabs.count + 1
        let tabName = name ?? "Tab \(newTabIndex)"
        let colorIndex = tabs.count % TabColors.all.count

        let newTab = Tab(name: tabName, colorIndex: colorIndex, type: type)
        tabs.append(newTab)
        activeTabId = newTab.id
        saveData()
        return newTab.id
    }

    func updateTabName(_ tabId: UUID, name: String) {
        guard let index = tabs.firstIndex(where: { $0.id == tabId }) else { return }
        // Limit to 5 characters
        let trimmedName = String(name.prefix(5))
        tabs[index].name = trimmedName
        saveData()
    }

    func deleteTab(_ tabId: UUID) {
        tabs.removeAll(where: { $0.id == tabId })

        // If active tab was deleted, select first tab
        if activeTabId == tabId {
            activeTabId = tabs.first?.id
        }

        saveData()
    }

    func addRow(to tabId: UUID, content: String) {
        guard let index = tabs.firstIndex(where: { $0.id == tabId }) else { return }
        let newRow = TextRow(content: content)
        tabs[index].rows.append(newRow)
        saveData()
    }

    func updateRow(in tabId: UUID, rowId: UUID, content: String) {
        guard let tabIndex = tabs.firstIndex(where: { $0.id == tabId }),
              let rowIndex = tabs[tabIndex].rows.firstIndex(where: { $0.id == rowId }) else { return }
        tabs[tabIndex].rows[rowIndex].content = content
        saveData()
    }

    func toggleRowExpansion(in tabId: UUID, rowId: UUID) {
        guard let tabIndex = tabs.firstIndex(where: { $0.id == tabId }),
              let rowIndex = tabs[tabIndex].rows.firstIndex(where: { $0.id == rowId }) else { return }

        // Collapse all other rows in this tab
        for i in 0..<tabs[tabIndex].rows.count {
            if tabs[tabIndex].rows[i].id != rowId {
                tabs[tabIndex].rows[i].isExpanded = false
            }
        }

        // Toggle the selected row
        tabs[tabIndex].rows[rowIndex].isExpanded.toggle()
    }

    func collapseAllRows(in tabId: UUID) {
        guard let tabIndex = tabs.firstIndex(where: { $0.id == tabId }) else { return }
        for i in 0..<tabs[tabIndex].rows.count {
            tabs[tabIndex].rows[i].isExpanded = false
        }
    }

    func deleteRow(in tabId: UUID, rowId: UUID) {
        guard let tabIndex = tabs.firstIndex(where: { $0.id == tabId }) else { return }
        tabs[tabIndex].rows.removeAll(where: { $0.id == rowId })
        saveData()
    }

    // MARK: - Persistence

    private func saveData() {
        let encoder = JSONEncoder()
        do {
            let tabsData = try encoder.encode(tabs)
            UserDefaults.standard.set(tabsData, forKey: saveKey)

            if let activeTabId = activeTabId {
                UserDefaults.standard.set(activeTabId.uuidString, forKey: "\(saveKey).activeTab")
            }
        } catch {
            print("Failed to save data: \(error)")
        }
    }

    private func loadData() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }

        let decoder = JSONDecoder()
        do {
            tabs = try decoder.decode([Tab].self, from: data)

            if let activeTabString = UserDefaults.standard.string(forKey: "\(saveKey).activeTab"),
               let uuid = UUID(uuidString: activeTabString) {
                activeTabId = uuid
            } else {
                activeTabId = tabs.first?.id
            }
        } catch {
            print("Failed to load data: \(error)")
        }
    }
}
