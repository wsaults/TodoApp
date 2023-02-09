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
    
    func test_save_item() async throws {
        let item = uniqueItem()
        let (sut, store) = makeSUT(result: .success(()))
        
        try await sut.save(item)
        
        XCTAssertEqual(store.receivedMessages, [.save([item])])
    }
    
    func test_save() async throws {
        let items = uniqueItems()
        let (sut, store) = makeSUT(result: .success(()))
        
        try await sut.save(items)
        
        XCTAssertEqual(store.receivedMessages, [.save(items)])
    }
    
    func test_save_failsOnSaveError() async {
        let (sut, _) = makeSUT(result: .failure(anyNSError))
        
        do {
            try await sut.save([])
            XCTFail("Expected error: \(anyNSError)")
        } catch {
            XCTAssertEqual(error as NSError?, anyNSError)
        }
    }
    
    func test_save_succeedsOnSuccessfulSave() async {
        let (sut, _) = makeSUT(result: .success(()))
        
        do {
            try await sut.save([])
        } catch {
            XCTFail("Received error: \(error)")
        }
    }
    
    // MARK: Helpers
    
    private func makeSUT(
        result: TodoStoreSpy.VoidResult = .failure(anyNSError),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocalTodoLoader, store: TodoStoreSpy) {
        let store = TodoStoreSpy(saveResult: result)
        let sut = LocalTodoLoader(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        
        return (sut, store)
    }
}
