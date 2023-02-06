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
    
    func test_delete_messagesStore() async throws {
        let item = uniqueItem()
        let (sut, store) = makeSUT(result: .success(()))
        
        try await sut.delete(item)
        
        XCTAssertEqual(store.receivedMessages, [.delete(item)])
    }
    
    func test_delete_failsOnDeletionError() async {
        let (sut, _) = makeSUT(result: .failure(anyNSError))
    
        do {
            try await sut.delete(uniqueItem())
            XCTFail("Expected error: \(anyNSError)")
        } catch {
            XCTAssertEqual(error as NSError?, anyNSError)
        }
    }
    
    func test_delete_succeedsOnSuccessfulDeletion() async {
        let (sut, _) = makeSUT(result: .success(()))
        
        do {
            try await sut.delete(uniqueItem())
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
        let store = TodoStoreSpy(deletionResult: result)
        let sut = LocalTodoLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalTodoLoader,
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        action()
        do {
            try await sut.delete(uniqueItem())
        } catch {
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
}
