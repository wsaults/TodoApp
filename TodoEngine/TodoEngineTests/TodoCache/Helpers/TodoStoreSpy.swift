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
        case save(TodoItem)
        case delete(TodoItem)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private var saveResult: Result<Void, Error>?
    private var deleteResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedTodos?, Error>?
    
    func save(_ item: TodoItem) throws {
        receivedMessages.append(.save(item))
        try saveResult?.get()
    }
    
    func delete(_ item: TodoItem) throws {
        receivedMessages.append(.delete(item))
        try deleteResult?.get()
    }
    
    func completeInsertion(with error: Error) {
        saveResult = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        saveResult = .success(())
    }
    
    func retrieve() throws -> CachedTodos? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache() {
        retrievalResult = .success(.none)
    }
    
    func completeRetrieval(with items: [TodoItem]) {
        retrievalResult = .success(CachedTodos(items))
    }
}
