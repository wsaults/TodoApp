//
//  TodoItemViewModel.swift
//  TodoEngine
//
//  Created by Will Saults on 2/5/23.
//

import Foundation

public struct TodoItemViewModel {
    public let uuid: UUID
    public let text: String
    public let createdAt: Date
    public let completedAt: Date?

    public var isComplete: Bool {
        completedAt != nil
    }
    
    public init(uuid: UUID, text: String, createdAt: Date, completedAt: Date? = nil) {
        self.uuid = uuid
        self.text = text
        self.createdAt = createdAt
        self.completedAt = completedAt
    }
}

extension TodoItemViewModel: Equatable {
    public static func == (lhs: TodoItemViewModel, rhs: TodoItemViewModel) -> Bool {
        lhs.text == rhs.text &&
        lhs.completedAt == rhs.completedAt
    }
}
