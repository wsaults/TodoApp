//
//  TodoItem.swift
//  TodoEngine
//
//  Created by Will Saults on 2/4/23.
//

import Foundation

struct TodoItem {
    let uuid: UUID
    let text: String?
    let createdAt: Date?
    let completedAt: Date?
}
