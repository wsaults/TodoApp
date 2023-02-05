//
//  TodoItemViewModel.swift
//  TodoEngine
//
//  Created by Will Saults on 2/5/23.
//

import Foundation

public struct TodoItemViewModel {
    public let text: String?
    public let createdAt: Date?
    let completedAt: Date?

    public var isComplete: Bool {
        completedAt != nil
    }
}
