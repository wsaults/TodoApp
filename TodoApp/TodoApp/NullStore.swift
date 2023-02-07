//
//  NullStore.swift
//  TodoApp
//
//  Created by Will Saults on 2/7/23.
//

import Foundation
import TodoEngine

class NullStore {}

extension NullStore: TodoStore {
    func save(_ items: [TodoItem]) async throws {}
    func retrieve() async throws -> CachedTodos { [] }
    func delete(_ item: TodoItem) async throws {}
}
