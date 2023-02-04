//
//  CachedTodosUseCaseTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import TodoEngine
import XCTest

class CachedTodosUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        
        try? sut.save(items)
        
        XCTAssertEqual(store.receivedMessages, [.save(items)])
    }
    
    func test_save_failsOnSaveError() {
        let (sut, store) = makeSUT()
        let saveError = anyNSError
        
        expect(sut, toCompleteWithError: saveError) {
            store.completeInsertion(with: saveError)
        }
    }
    
    func test_save_succeedsOnSuccessfulSave() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil) {
            store.completeInsertionSuccessfully()
        }
    }
    
    // MARK: Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocalTodoLoader, store: TodoStoreSpy) {
        let store = TodoStoreSpy()
        let sut = LocalTodoLoader(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalTodoLoader,
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()
        do {
            try sut.save([uniqueItem(), uniqueItem()])
        } catch {
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
    
    private func uniqueItem() -> TodoItem {
        TodoItem(uuid: UUID(), text: "any", createdAt: anyDate, completedAt: anyDate)
    }
}
