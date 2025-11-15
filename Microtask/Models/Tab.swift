//
//  Tab.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import Foundation
import SwiftUI

enum TabType: String, Codable, Equatable {
    case note
    case task
}

struct Tab: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var colorIndex: Int
    var type: TabType
    var rows: [TextRow]

    init(id: UUID = UUID(), name: String, colorIndex: Int, type: TabType = .note, rows: [TextRow] = []) {
        self.id = id
        self.name = name
        self.colorIndex = colorIndex
        self.type = type
        self.rows = rows
    }

    var color: Color {
        TabColors.all[colorIndex % TabColors.all.count].color
    }

    var abbreviation: String {
        String(name.prefix(1)).uppercased()
    }
}

// Color palette for tabs
struct TabColorDefinition {
    let color: Color
    let name: String
}

struct TabColors {
    static let all: [TabColorDefinition] = [
        TabColorDefinition(color: Color(red: 0.20, green: 0.25, blue: 0.35), name: "Ink"),       // Newspaper Ink
        TabColorDefinition(color: Color(red: 0.55, green: 0.35, blue: 0.30), name: "Sepia"),     // Vintage Sepia
        TabColorDefinition(color: Color(red: 0.30, green: 0.40, blue: 0.35), name: "Forest"),    // Deep Forest
        TabColorDefinition(color: Color(red: 0.45, green: 0.35, blue: 0.25), name: "Tobacco"),   // Tobacco Brown
        TabColorDefinition(color: Color(red: 0.35, green: 0.30, blue: 0.45), name: "Plum"),      // Muted Plum
        TabColorDefinition(color: Color(red: 0.50, green: 0.45, blue: 0.30), name: "Olive"),     // Olive
        TabColorDefinition(color: Color(red: 0.30, green: 0.40, blue: 0.45), name: "Slate"),     // Slate Blue
        TabColorDefinition(color: Color(red: 0.45, green: 0.30, blue: 0.35), name: "Burgundy"),  // Burgundy
    ]
}
