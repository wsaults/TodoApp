//
//  TodoStoreSpy.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import Foundation
import TodoEngine

class TodoStoreSpy: TodoStore {
    enum ReceivedMessage: Equatable {
        case save([TodoItem])
        case delete(TodoItem)
        case retrieve
    }
    
    typealias VoidResult = Result<Void, Error>
    typealias CachedResult = Result<CachedTodos, Error>
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private let saveResult: VoidResult
    private let deletionResult: VoidResult
    private let receivedResult: CachedResult
    
    init(
        receivedResult: CachedResult = .failure(anyNSError),
        saveResult: VoidResult = .failure(anyNSError),
        deletionResult: VoidResult = .failure(anyNSError)
    ) {
        self.receivedResult = receivedResult
        self.saveResult = saveResult
        self.deletionResult = deletionResult
    }
    
    func save(_ items: [TodoItem]) throws {
        receivedMessages.append(.save(items))
        _ = try saveResult.get()
    }
    
    func delete(_ item: TodoItem) throws {
        receivedMessages.append(.delete(item))
        _ = try deletionResult.get()
    }
    
    func retrieve() throws -> CachedTodos {
        receivedMessages.append(.retrieve)
        return try receivedResult.get()
    }
}
