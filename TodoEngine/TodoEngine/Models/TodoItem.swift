//
//  TodoItem.swift
//  TodoEngine
//
//  Created by Will Saults on 2/4/23.
//

import Foundation

public struct TodoItem {
    let uuid: UUID
    let text: String?
    let createdAt: Date?
    let completedAt: Date?
    
    public init(uuid: UUID, text: String? = nil, createdAt: Date? = nil, completedAt: Date? = nil) {
        self.uuid = uuid
        self.text = text
        self.createdAt = createdAt
        self.completedAt = completedAt
    }
}
