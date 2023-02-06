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
    
    func test_load_requestsCacheRetrieval() async throws {
        let (sut, store) = makeSUT(result: .success([]))

        _ = try await sut.load()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() async {
        let (sut, _) = makeSUT(result: .failure(anyNSError))
        
        do {
            _ = try await sut.load()
            XCTFail("Expected error: \(anyNSError)")
        } catch {
            XCTAssertEqual(error as NSError?, anyNSError)
        }
    }
    
    func test_load_deliversNoTodosOnEmptyCache() async {
        let (sut, _) = makeSUT(result: .success([]))
        
        do {
            let items = try await sut.load()
            XCTAssertEqual(items, [])
        } catch {
            XCTFail("Received error: \(error)")
        }
    }
    
    func test_load_deliversCachedTodos() async {
        let expectedItems = uniqueItems()
        let (sut, store) = makeSUT(result: .success(expectedItems))

        do {
            let recievedItems = try await sut.load()
            XCTAssertEqual(recievedItems, expectedItems)
            XCTAssertEqual(store.receivedMessages, [.retrieve])
        } catch {
            XCTFail("Received error: \(error)")
        }
    }
    
    // MARK: Helpers

    private func makeSUT(
        result: Result<[TodoItem], Error> = .failure(anyNSError),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocalTodoLoader, store: TodoStoreSpy) {
        let store = TodoStoreSpy(receivedResult: result)
        let sut = LocalTodoLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
}
