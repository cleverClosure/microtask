//
//  TextRow.swift
//  Microtask
//
//  Created by Tim Isaev on 08.11.2025.
//

import Foundation

struct TextRow: Identifiable, Codable, Equatable {
    let id: UUID
    var content: String
    var isExpanded: Bool
    var createdAt: Date

    init(id: UUID = UUID(), content: String = "", isExpanded: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.content = content
        self.isExpanded = isExpanded
        self.createdAt = createdAt
    }
}
