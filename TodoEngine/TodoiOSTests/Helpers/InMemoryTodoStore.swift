//
//  InMemoryTodoStore.swift
//  TodoAppTests
//
//  Created by Will Saults on 2/7/23.
//

import Foundation
import TodoEngine

class InMemoryTodoStore {
    private(set) var todoCache = CachedTodos()
    
    private init(todoCache: CachedTodos) {
        self.todoCache = todoCache
    }
}

extension InMemoryTodoStore: TodoStore {
    func save(_ items: [TodoItem]) async throws {
        todoCache = CachedTodos(items)
    }
    
    func save(_ item: TodoItem) async throws {
        todoCache.removeAll { $0.uuid == item.uuid }
        todoCache.append(item)
    }
    
    func retrieve() async throws -> CachedTodos {
        todoCache
    }
    
    func delete(_ item: TodoItem) async throws {
        todoCache = []
    }
}

extension InMemoryTodoStore {
    static var empty: InMemoryTodoStore {
        InMemoryTodoStore(todoCache: CachedTodos([]))
    }
    
    static var withTodosCache: InMemoryTodoStore {
        InMemoryTodoStore(todoCache: CachedTodos([
            TodoItem(uuid: UUID(), text: "Todo one", createdAt: Date.now),
            TodoItem(uuid: UUID(), text: "Todo two", createdAt: Date.now)
        ]))
    }
}
