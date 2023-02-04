//
//  LoadTodosFromCacheUseCaseTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import TodoEngine
import XCTest

class LoadTodosFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()

        _ = try? sut.load()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError

        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_load_deliversNoTodosOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }
    
    func test_load_deliversCachedTodos() {
        let items = uniqueItems()
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success(items)) {
            store.completeRetrieval(with: items)
        }
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
    
    private func expect(
        _ sut: LocalTodoLoader,
        toCompleteWith expectedResult: Result<[TodoItem], Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        action()

        let receivedResult = Result { try sut.load() }

        switch (receivedResult, expectedResult) {
        case let (.success(receivedImages), .success(expectedImages)):
            XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
