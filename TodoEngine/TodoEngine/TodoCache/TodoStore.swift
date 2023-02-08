//
//  TodoStore.swift
//  TodoEngine
//
//  Created by Will Saults on 2/4/23.
//

import Foundation

public typealias CachedTodos = [TodoItem]

public protocol TodoStore {
    func save(_ items: [TodoItem]) async throws
    func save(_ item: TodoItem) async throws 
    func retrieve() async throws -> CachedTodos
    func delete(_ item: TodoItem) async throws
}
