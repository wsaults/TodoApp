//
//  DeleteTodosFromCacheUseCaseTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import TodoEngine
import XCTest

class DeleteTodosFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_delete_savedLastTodoLeavesZeroTodos() {
        let item = uniqueItem()
        let (sut, store) = makeSUT()
        
        try? sut.save(item)
        try? sut.delete(item)
        
        XCTAssertEqual(store.receivedMessages, [.save(item), .delete(item)])
        XCTAssertEqual(try sut.load().count, 0)
    }
    
    // MARK: Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocalTodoLoader, store: TodoStoreSpy) {
        let store = TodoStoreSpy()
        let sut = LocalTodoLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}
