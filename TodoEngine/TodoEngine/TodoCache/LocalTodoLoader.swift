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
    public func save(_ items: [TodoItem]) async throws {
        try await store.save(items)
    }
    
    public func save(_ item: TodoItem) async throws {
        try await store.save(item)
    }
}

extension LocalTodoLoader: TodoLoader {
    public func load() async throws -> [TodoItem] {
        try await store.retrieve()
    }
}

extension LocalTodoLoader: TodoDeleter {
    public func delete(_ item: TodoItem) async throws {
        try await store.delete(item)
    }
}
