//
//  TodoCacheIntegrationTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/5/23.
//

import TodoEngine
import XCTest

class TodoCacheIntegrationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        setupEmptyStoreState()
    }

    override func tearDown() {
        super.tearDown()

        undoStoreSideEffects()
    }
    
    // MARK: LocalTodoLoader Tests

    func test_loadTodos_deliversNoItemsOnEmptyCache() async {
        let todoLoader = makeTodoLoader()

        await expect(todoLoader, toLoad: [])
    }
    
    func test_loadTodos_deliversItemsSavedOnASeparateInstance() async {
        let todoLoaderToPerformSave = makeTodoLoader()
        let todoLoaderToPerformLoad = makeTodoLoader()
        let todos = uniqueItems()

        await save(todos, with: todoLoaderToPerformSave)

        await expect(todoLoaderToPerformLoad, toLoad: todos)
    }
    
    func test_loadTodos_overridesItemsSavedOnASeparateInstance() async {
        let todoLoaderToPerformFirstSave = makeTodoLoader()
        let todoLoaderToPerformLastSave = makeTodoLoader()
        let todoLoaderToPerformLoad = makeTodoLoader()
        let firstTodos = uniqueItems()
        let latestTodos = uniqueItems()

        await save(firstTodos, with: todoLoaderToPerformFirstSave)
        await save(latestTodos, with: todoLoaderToPerformLastSave)

        await expect(todoLoaderToPerformLoad, toLoad: latestTodos)
    }
    
    // MARK: Helpers

    private func makeTodoLoader(file: StaticString = #filePath, line: UInt = #line) -> LocalTodoLoader {
        let store = try! FileManagerTodoStore(storeURL: testSpecificStoreURL())
        let sut = LocalTodoLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func save(_ todos: [TodoItem], with loader: LocalTodoLoader, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            try await loader.save(todos)
        } catch {
            XCTFail("Expected to save todos successfully, got error: \(error)", file: file, line: line)
        }
    }
    
    private func expect(_ sut: LocalTodoLoader, toLoad expectedTodos: [TodoItem], file: StaticString = #filePath, line: UInt = #line) async {
        do {
            let loadedTodos = try await sut.load()
            XCTAssertEqual(loadedTodos, expectedTodos, file: file, line: line)
        } catch {
            XCTFail("Expected successful todos result, got \(error) instead", file: file, line: line)
        }
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }

    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }

    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    func testSpecificStoreURL() -> URL {
        cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
}
