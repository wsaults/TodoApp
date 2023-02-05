//
//  TodoCacheIntegrationTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/5/23.
//

import TodoEngine
import XCTest

class TodoCacheIntegrationTests: XCTestCase {
    
    // MARK: LocalTodoLoader Tests

    func test_loadTodos_deliversNoItemsOnEmptyCache() {
        let todoLoader = makeTodoLoader()

        expect(todoLoader, toLoad: [])
    }
    
    // MARK: Helpers

    private func makeTodoLoader(file: StaticString = #filePath, line: UInt = #line) -> LocalTodoLoader {
        let store = try! FileManagerTodoStore(storeURL: testSpecificStoreURL())
        let sut = LocalTodoLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: LocalTodoLoader, toLoad expectedTodos: [TodoItem], file: StaticString = #filePath, line: UInt = #line) {
        do {
            let loadedTodos = try sut.load()
            XCTAssertEqual(loadedTodos, expectedTodos, file: file, line: line)
        } catch {
            XCTFail("Expected successful todos result, got \(error) instead", file: file, line: line)
        }
    }
    
    func testSpecificStoreURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
}
