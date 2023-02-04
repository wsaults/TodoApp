//
//  LocalTodoLoader.swift
//  TodoEngine
//
//  Created by Will Saults on 2/4/23.
//

import Foundation

public final class LocalTodoLoader {
    private let store: TodoStore
    
    public init(store: TodoStore) {
        self.store = store
    }
}

extension LocalTodoLoader: TodoCache {
    public func save(_ items: [TodoItem]) throws {
        try store.save(items)
    }
}
