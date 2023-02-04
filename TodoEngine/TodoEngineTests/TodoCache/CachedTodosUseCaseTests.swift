//
//  CachedTodosUseCaseTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import XCTest

class LocalTodoLoader {
    init(store: TodoStore) {
        
    }
}

class TodoStore {
    var deleteCachedTodoCallCount = 0
}

class CachedTodosUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = TodoStore()
        _ = LocalTodoLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedTodoCallCount, 0)
    }
}
