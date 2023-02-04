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
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private var saveResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedTodos?, Error>?
    
    func save(_ items: [TodoItem]) throws {
        receivedMessages.append(.save(items))
        try saveResult?.get()
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
}
