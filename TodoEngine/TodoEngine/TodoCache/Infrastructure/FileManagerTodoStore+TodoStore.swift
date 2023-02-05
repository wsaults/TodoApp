//
//  FileManagerTodoStore+TodoStore.swift
//  TodoEngine
//
//  Created by Will Saults on 2/5/23.
//

import Foundation

extension FileManagerTodoStore: TodoStore {
    
    public func save(_ items: [TodoItem]) throws {
        let data = try JSONEncoder().encode(items)
        let outfile = self.storeURL
        try data.write(to: outfile)
    }
    
    public func retrieve() throws -> CachedTodos? {
        let fileURL = self.storeURL
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
            return nil
        }
        return try JSONDecoder().decode(CachedTodos.self, from: file.availableData)
    }
    
    public func delete(_ item: TodoItem) throws {
        var todos = try retrieve()
        todos?.removeAll { $0.uuid == item.uuid }
        if let todos = todos {
            try save(todos)
        }
    }
}
