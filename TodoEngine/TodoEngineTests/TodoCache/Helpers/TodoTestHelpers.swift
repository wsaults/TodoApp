//
//  TodoTestHelpers.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import TodoEngine
import Foundation

func uniqueItem() -> TodoItem {
    TodoItem(uuid: UUID(), text: "any", createdAt: anyDate, completedAt: anyDate)
}

func uniqueItems() -> [TodoItem] {
    [uniqueItem(), uniqueItem()]
}
