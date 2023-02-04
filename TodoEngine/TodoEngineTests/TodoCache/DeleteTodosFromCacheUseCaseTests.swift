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
    
    func test_delete() {
        let item1 = uniqueItem()
        let item2 = uniqueItem()
        let items = [item1, item2]
        let (sut, store) = makeSUT()
        
        try? sut.save(items)
        try? sut.delete(item1)
        
        XCTAssertEqual(store.receivedMessages, [.save(items), .delete(item1)])
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
