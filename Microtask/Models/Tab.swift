//
//  Tab.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import Foundation
import SwiftUI

struct Tab: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var colorIndex: Int
    var rows: [TextRow]

    init(id: UUID = UUID(), name: String, colorIndex: Int, rows: [TextRow] = []) {
        self.id = id
        self.name = name
        self.colorIndex = colorIndex
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
        TabColorDefinition(color: Color(red: 0.35, green: 0.61, blue: 0.93), name: "Blue"),      // Soft Blue
        TabColorDefinition(color: Color(red: 0.93, green: 0.42, blue: 0.42), name: "Red"),       // Coral Red
        TabColorDefinition(color: Color(red: 0.42, green: 0.82, blue: 0.58), name: "Green"),     // Mint Green
        TabColorDefinition(color: Color(red: 0.95, green: 0.68, blue: 0.38), name: "Orange"),    // Warm Orange
        TabColorDefinition(color: Color(red: 0.71, green: 0.52, blue: 0.93), name: "Purple"),    // Lavender Purple
        TabColorDefinition(color: Color(red: 0.93, green: 0.76, blue: 0.42), name: "Yellow"),    // Golden Yellow
        TabColorDefinition(color: Color(red: 0.42, green: 0.76, blue: 0.87), name: "Cyan"),      // Sky Cyan
        TabColorDefinition(color: Color(red: 0.93, green: 0.51, blue: 0.73), name: "Pink"),      // Rose Pink
    ]
}
