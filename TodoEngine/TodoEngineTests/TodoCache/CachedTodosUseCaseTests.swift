//
//  CachedTodosUseCaseTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import TodoEngine
import XCTest

class LocalTodoLoader {
    private let store: TodoStore
    
    init(store: TodoStore) {
        self.store = store
    }
    
    func save(_ items: [TodoItem]) {
        store.save()
    }
}

class TodoStore {
    var deleteCachedTodoCallCount = 0
    var savedCachedTodoCallCount = 0
    
    func save() {
        savedCachedTodoCallCount += 1
    }
}

class CachedTodosUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCachedTodoCallCount, 0)
    }
    
    func test_save() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedTodoCallCount, 0)
        XCTAssertEqual(store.savedCachedTodoCallCount, 1)
    }
    
    // MARK: Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocalTodoLoader, store: TodoStore) {
        let store = TodoStore()
        let sut = LocalTodoLoader(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private func uniqueItem() -> TodoItem {
        TodoItem(uuid: UUID(), text: "any", createdAt: anyDate, completedAt: anyDate)
    }
    
    private let anyDate = Date()
}
