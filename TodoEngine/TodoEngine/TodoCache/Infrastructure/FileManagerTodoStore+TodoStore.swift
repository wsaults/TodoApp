//
//  FileManagerTodoStore+TodoStore.swift
//  TodoEngine
//
//  Created by Will Saults on 2/5/23.
//

import Foundation

extension FileManagerTodoStore: TodoStore {
    
    public func save(_ items: [TodoItem]) async throws -> Void {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let data = try JSONEncoder().encode(items)
                let outfile = self.storeURL
                try data.write(to: outfile)
                continuation.resume()
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }
    
    public func retrieve() async throws -> CachedTodos {
        try await Task.detached(priority: .userInitiated) {
            guard let file = try? FileHandle(forReadingFrom: self.storeURL) else {
                return []
            }
            return try JSONDecoder().decode(CachedTodos.self, from: file.availableData)
        }.value
    }
        
    public func delete(_ item: TodoItem) async throws {
        var todos = try await retrieve()
        todos.removeAll { $0.uuid == item.uuid }
        try await save(todos)
    }
}
