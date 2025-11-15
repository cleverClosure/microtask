//
//  MicrotaskTests.swift
//  MicrotaskTests
//
//  Created by Tim Isaev on 06.11.2025.
//

import Testing
import Foundation
@testable import Microtask

@MainActor
struct MicrotaskTests {
    // Use a unique test storage key to avoid polluting production data
    static let testStorageKey = "microtask.appstate.test.\(UUID().uuidString)"

    // Helper to create test AppState with isolated storage
    func createTestAppState() -> AppState {
        let appState = AppState(storageKey: Self.testStorageKey)
        return appState
    }

    // Helper to clean up test data
    func cleanupTestData() {
        UserDefaults.standard.removeObject(forKey: Self.testStorageKey)
        UserDefaults.standard.removeObject(forKey: "\(Self.testStorageKey).activeTab")
    }

    // Helper to clean up leaked test data from production storage
    // Run this test ONCE to remove test tabs that polluted your real data
    @Test("CLEANUP: Remove leaked test tabs from production data")
    func cleanupLeakedTestData() {
        let productionKey = "microtask.appstate"

        // Load production data
        guard let data = UserDefaults.standard.data(forKey: productionKey) else {
            print("No production data found")
            return
        }

        let decoder = JSONDecoder()
        do {
            var tabs = try decoder.decode([Tab].self, from: data)
            let originalCount = tabs.count

            // Common test tab names to remove
            let testTabNames = ["Test", "Old", "New", "NewTab", "ToDelete", "VeryL"]

            // Filter out test tabs - keep only tabs that:
            // 1. Are named "Notes" or "Tasks" (the production tabs)
            // 2. Don't match common test names
            tabs = tabs.filter { tab in
                let isProductionTab = tab.name == "Notes" || tab.name == "Tasks"
                let isTestTab = testTabNames.contains(tab.name) || tab.name.hasPrefix("Tab ")
                return isProductionTab || !isTestTab
            }

            let removedCount = originalCount - tabs.count
            print("Removed \(removedCount) test tabs (from \(originalCount) to \(tabs.count))")

            if removedCount > 0 {
                // Save cleaned data
                let encoder = JSONEncoder()
                let cleanedData = try encoder.encode(tabs)
                UserDefaults.standard.set(cleanedData, forKey: productionKey)

                // Reset active tab to first tab if needed
                if let firstTab = tabs.first {
                    UserDefaults.standard.set(firstTab.id.uuidString, forKey: "\(productionKey).activeTab")
                }

                print("✅ Production data cleaned! Removed test tabs:")
                print("   Kept tabs: \(tabs.map { $0.name }.joined(separator: ", "))")
            } else {
                print("✅ No test tabs found in production data")
            }
        } catch {
            print("Failed to clean production data: \(error)")
        }
    }

    @Test("Tab creation assigns correct properties")
    func testTabCreation() {
        let tab = Tab(name: "Work", colorIndex: 0, type: .note)

        #expect(tab.name == "Work")
        #expect(tab.colorIndex == 0)
        #expect(tab.type == .note)
        #expect(tab.rows.isEmpty)
    }

    @Test("Tab abbreviation is first letter uppercased")
    func testTabAbbreviation() {
        let tab1 = Tab(name: "work", colorIndex: 0, type: .note)
        let tab2 = Tab(name: "Home", colorIndex: 1, type: .task)

        #expect(tab1.abbreviation == "W")
        #expect(tab2.abbreviation == "H")
    }

    @Test("TextRow creation with default values")
    func testTextRowCreation() {
        let row = TextRow(content: "Test task")

        #expect(row.content == "Test task")
        #expect(row.isExpanded == false)
    }

    @Test("AppState creates default tabs on initialization")
    func testAppStateDefaultTab() {
        let appState = createTestAppState()
        defer { cleanupTestData() }

        #expect(appState.tabs.count == 2)
        #expect(appState.tabs[0].name == "Notes")
        #expect(appState.tabs[0].type == .note)
        #expect(appState.tabs[1].name == "Tasks")
        #expect(appState.tabs[1].type == .task)
        #expect(appState.activeTabId == appState.tabs[0].id)
    }

    @Test("Update tab name changes name correctly")
    func testUpdateTabName() {
        let appState = createTestAppState()
        defer { cleanupTestData() }

        appState.createTab(name: "Old", type: .note)

        guard let tabId = appState.tabs.last?.id else {
            Issue.record("Tab not created")
            return
        }

        appState.updateTabName(tabId, name: "New")

        let updatedTab = appState.tabs.first(where: { $0.id == tabId })
        #expect(updatedTab?.name == "New")
    }

    @Test("Update tab name enforces 5 character limit")
    func testTabNameCharacterLimit() {
        let appState = createTestAppState()
        defer { cleanupTestData() }

        appState.createTab(name: "Test", type: .note)

        guard let tabId = appState.tabs.last?.id else {
            Issue.record("Tab not created")
            return
        }

        appState.updateTabName(tabId, name: "VeryLongName")

        let updatedTab = appState.tabs.first(where: { $0.id == tabId })
        #expect(updatedTab?.name == "VeryL")
        #expect(updatedTab?.name.count == 5)
    }

    @Test("Adding row to tab increases row count")
    func testAddRow() {
        let appState = createTestAppState()
        defer { cleanupTestData() }

        appState.createTab(name: "Test", type: .note)

        guard let tabId = appState.tabs.last?.id else {
            Issue.record("Tab not created")
            return
        }

        appState.addRow(to: tabId, content: "New task")

        let tab = appState.tabs.first(where: { $0.id == tabId })
        #expect(tab?.rows.count == 1)
        #expect(tab?.rows.first?.content == "New task")
    }

    @Test("Update row content changes row correctly")
    func testUpdateRow() {
        let appState = createTestAppState()
        defer { cleanupTestData() }

        appState.createTab(name: "Test", type: .note)

        guard let tabId = appState.tabs.last?.id else {
            Issue.record("Tab not created")
            return
        }

        appState.addRow(to: tabId, content: "Original")

        guard let rowId = appState.tabs.last?.rows.first?.id else {
            Issue.record("Row not created")
            return
        }

        appState.updateRow(in: tabId, rowId: rowId, content: "Updated")

        let tab = appState.tabs.first(where: { $0.id == tabId })
        let row = tab?.rows.first(where: { $0.id == rowId })
        #expect(row?.content == "Updated")
    }

    @Test("Toggle row expansion changes expansion state")
    func testToggleRowExpansion() {
        let appState = createTestAppState()
        defer { cleanupTestData() }

        appState.createTab(name: "Test", type: .note)

        guard let tabId = appState.tabs.last?.id else {
            Issue.record("Tab not created")
            return
        }

        appState.addRow(to: tabId, content: "Task")

        guard let rowId = appState.tabs.last?.rows.first?.id else {
            Issue.record("Row not created")
            return
        }

        appState.toggleRowExpansion(in: tabId, rowId: rowId)

        let tab = appState.tabs.first(where: { $0.id == tabId })
        let row = tab?.rows.first(where: { $0.id == rowId })
        #expect(row?.isExpanded == true)

        appState.toggleRowExpansion(in: tabId, rowId: rowId)
        let tab2 = appState.tabs.first(where: { $0.id == tabId })
        let row2 = tab2?.rows.first(where: { $0.id == rowId })
        #expect(row2?.isExpanded == false)
    }

    @Test("Only one row can be expanded at a time")
    func testSingleRowExpansion() {
        let appState = createTestAppState()
        defer { cleanupTestData() }

        appState.createTab(name: "Test", type: .note)

        guard let tabId = appState.tabs.last?.id else {
            Issue.record("Tab not created")
            return
        }

        appState.addRow(to: tabId, content: "Task 1")
        appState.addRow(to: tabId, content: "Task 2")

        guard let tab = appState.tabs.first(where: { $0.id == tabId }),
              tab.rows.count >= 2 else {
            Issue.record("Rows not created")
            return
        }

        let row1Id = tab.rows[0].id
        let row2Id = tab.rows[1].id

        // Expand first row
        appState.toggleRowExpansion(in: tabId, rowId: row1Id)

        // Expand second row
        appState.toggleRowExpansion(in: tabId, rowId: row2Id)

        let updatedTab = appState.tabs.first(where: { $0.id == tabId })
        let updatedRow1 = updatedTab?.rows.first(where: { $0.id == row1Id })
        let updatedRow2 = updatedTab?.rows.first(where: { $0.id == row2Id })

        #expect(updatedRow1?.isExpanded == false)
        #expect(updatedRow2?.isExpanded == true)
    }

    @Test("Delete row removes row from tab")
    func testDeleteRow() {
        let appState = createTestAppState()
        defer { cleanupTestData() }

        appState.createTab(name: "Test", type: .note)

        guard let tabId = appState.tabs.last?.id else {
            Issue.record("Tab not created")
            return
        }

        appState.addRow(to: tabId, content: "Task to delete")

        guard let rowId = appState.tabs.last?.rows.first?.id else {
            Issue.record("Row not created")
            return
        }

        appState.deleteRow(in: tabId, rowId: rowId)

        let tab = appState.tabs.first(where: { $0.id == tabId })
        #expect(tab?.rows.isEmpty == true)
    }

    @Test("Delete tab removes tab from list")
    func testDeleteTab() {
        let appState = createTestAppState()
        defer { cleanupTestData() }

        appState.createTab(name: "ToDelete", type: .note)

        guard let tabId = appState.tabs.last?.id else {
            Issue.record("Tab not created")
            return
        }

        let initialCount = appState.tabs.count

        appState.deleteTab(tabId)

        #expect(appState.tabs.count == initialCount - 1)
        #expect(appState.tabs.contains(where: { $0.id == tabId }) == false)
    }

    @Test("Collapse all rows collapses all rows in tab")
    func testCollapseAllRows() {
        let appState = createTestAppState()
        defer { cleanupTestData() }

        appState.createTab(name: "Test", type: .note)

        guard let tabId = appState.tabs.last?.id else {
            Issue.record("Tab not created")
            return
        }

        appState.addRow(to: tabId, content: "Task 1")
        appState.addRow(to: tabId, content: "Task 2")

        guard let tab = appState.tabs.first(where: { $0.id == tabId }),
              tab.rows.count >= 2 else {
            Issue.record("Rows not created")
            return
        }

        // Expand a row
        appState.toggleRowExpansion(in: tabId, rowId: tab.rows[0].id)

        // Collapse all
        appState.collapseAllRows(in: tabId)

        let updatedTab = appState.tabs.first(where: { $0.id == tabId })
        let allCollapsed = updatedTab?.rows.allSatisfy { !$0.isExpanded } ?? false
        #expect(allCollapsed == true)
    }
}

