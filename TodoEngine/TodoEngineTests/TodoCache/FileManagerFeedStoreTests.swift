//
//  FileManagerTodoStoreTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import TodoEngine
import XCTest

class FileManagerTodoStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        expect(makeSUT(), toRetrieve: .success(.none))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        expect(makeSUT(), toRetrieveTwice: .success(.none))
    }
    
    func test_retrieve_deliversFoundValueOnNonEmptyCache() {
        let sut = makeSUT()
        let items = uniqueItems()

        save(items, to: sut)

        expect(sut, toRetrieve: .success(CachedTodos(items)))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let items = uniqueItems()

        save(items, to: sut)

        expect(sut, toRetrieveTwice: .success(CachedTodos(items)))
    }
    
    func test_save_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()

        let saveError = save(uniqueItems(), to: sut)

        XCTAssertNil(saveError, "Expected to save cache successfully")
    }
    
    func test_save_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()

        save(uniqueItems(), to: sut)

        let saveError = save(uniqueItems(), to: sut)

        XCTAssertNil(saveError, "Expected to override cache successfully")
    }
    
    func test_save_overridesPreviouslySavedCacheValues() {
        let sut = makeSUT()

        save(uniqueItems(), to: sut)

        let latestItems = uniqueItems()
        save(latestItems, to: sut)

        expect(sut, toRetrieve: .success(CachedTodos(latestItems)))
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()

        let item1 = uniqueItem()
        let item2 = uniqueItem()
        save([item1, item2], to: sut)

        let deletionError = delete(item1 , from: sut)

        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
    }
    
    func test_delete_removesPreviouslySavedItem() {
        let sut = makeSUT()

        let item1 = uniqueItem()
        let item2 = uniqueItem()
        save([item1, item2], to: sut)

        delete(item1 , from: sut)

        expect(sut, toRetrieve: .success(CachedTodos([item2])))
    }
    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> TodoStore {
        let storeURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        let sut = try! FileManagerTodoStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    @discardableResult
    func save(_ items: [TodoItem], to sut: TodoStore) -> Error? {
        do {
            try sut.save(items)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func delete(_ item: TodoItem, from sut: TodoStore) -> Error? {
        do {
            try sut.delete(item)
            return nil
        } catch {
            return error
        }
    }
    
    func expect(_ sut: TodoStore, toRetrieveTwice expectedResult: Result<CachedTodos?, Error>, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: TodoStore, toRetrieve expectedResult: Result<CachedTodos?, Error>, file: StaticString = #filePath, line: UInt = #line) {
        let retrievedResult = Result { try sut.retrieve() }
        
        switch (expectedResult, retrievedResult) {
        case (.success(.none), .success(.none)),
            (.failure, .failure):
            break
            
        case let (.success(.some(expected)), .success(.some(retrieved))):
            XCTAssertEqual(retrieved, expected, file: file, line: line)
            
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
}
