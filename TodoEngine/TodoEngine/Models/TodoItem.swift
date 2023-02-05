//
//  TodoItem.swift
//  TodoEngine
//
//  Created by Will Saults on 2/4/23.
//

import Foundation

public struct TodoItem: Equatable, Codable {
    public let uuid: UUID
    public let text: String
    public let createdAt: Date
    public let completedAt: Date?
    
    public init(uuid: UUID, text: String, createdAt: Date, completedAt: Date? = nil) {
        self.uuid = uuid
        self.text = text
        self.createdAt = createdAt
        self.completedAt = completedAt
    }
}
