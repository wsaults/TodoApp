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
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    private var saveResult: Result<Void, Error>?
    
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
}
