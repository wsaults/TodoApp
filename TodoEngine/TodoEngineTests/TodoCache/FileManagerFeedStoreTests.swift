//
//  FileManagerTodoStoreTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import TodoEngine
import XCTest

class FileManagerTodoStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() async {
        await expect(makeSUT(), toRetrieve: .success([]))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() async {
        await expect(makeSUT(), toRetrieveTwice: .success([]))
    }
    
    func test_retrieve_deliversFoundValueOnNonEmptyCache() async {
        let sut = makeSUT()
        let items = uniqueItems()

        await save(items, to: sut)

        await expect(sut, toRetrieve: .success(CachedTodos(items)))
    }
    
    func test_retrieve_deliversItemsByTheDateTheyWereAdded() async {
        let sut = makeSUT()
        
        let item1 = TodoItem(uuid: UUID(), text: "Fourth", createdAt: Date.now.addHours(-1))
        let item2 = TodoItem(uuid: UUID(), text: "Second", createdAt: Date.now.addHours(-3))
        let item3 = TodoItem(uuid: UUID(), text: "Third", createdAt: Date.now.addHours(-2))
        let item4 = TodoItem(uuid: UUID(), text: "First", createdAt: Date.now.addDays(-1))

        await save([item1, item2, item3, item4], to: sut)

        await expect(sut, toRetrieve: .success(CachedTodos(
            [item4, item2, item3, item1]
        )))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() async {
        let sut = makeSUT()
        let items = uniqueItems()

        await save(items, to: sut)

        await expect(sut, toRetrieveTwice: .success(CachedTodos(items)))
    }
    
    func test_saveItem_deliversNoErrorOnEmptyCache() async {
        let sut = makeSUT()

        let saveError = await save(uniqueItem(), to: sut)

        XCTAssertNil(saveError, "Expected to save cache successfully")
    }
    
    func test_saveItem_deliversNoErrorOnNonEmptyCache() async {
        let sut = makeSUT()

        await save(uniqueItem(), to: sut)

        let saveError = await save(uniqueItem(), to: sut)

        XCTAssertNil(saveError, "Expected to override cache successfully")
    }
    
    func test_saveItem_deliversErrorOnBadStoreURL() async {
        let badStoreURL = cachesDirectory()
        let sut = try! FileManagerTodoStore(storeURL: badStoreURL)

        let saveError = await save(uniqueItem(), to: sut)
        XCTAssertNotNil(saveError, "Expected save error")
    }
    
    func test_saveItem_overridePreviouslySavedItem() async {
        let sut = makeSUT()

        let item = TodoItem(uuid: UUID(), text: "any", createdAt: Date.now)
        await save(item, to: sut)

        let updatedItem = TodoItem(uuid: item.uuid, text: "anything else", createdAt: item.createdAt)
        await save(updatedItem, to: sut)

        await expect(sut, toRetrieve: .success(CachedTodos([updatedItem])))
    }
    
    func test_saveItem_doesNotOverridePreviouslySavedCacheValues() async {
        let sut = makeSUT()

        let firstItem = TodoItem(uuid: UUID(), text: "any", createdAt: Date.now.addHours(-1))
        await save(firstItem, to: sut)

        let secondItem = TodoItem(uuid: UUID(), text: "any", createdAt: Date.now)
        await save(secondItem, to: sut)

        await expect(sut, toRetrieve: .success(CachedTodos([firstItem, secondItem])))
    }
    
    func test_save_deliversNoErrorOnEmptyCache() async {
        let sut = makeSUT()

        let saveError = await save(uniqueItems(), to: sut)

        XCTAssertNil(saveError, "Expected to save cache successfully")
    }
    
    func test_save_deliversNoErrorOnNonEmptyCache() async {
        let sut = makeSUT()

        await save(uniqueItems(), to: sut)

        let saveError = await save(uniqueItems(), to: sut)

        XCTAssertNil(saveError, "Expected to override cache successfully")
    }
    
    func test_save_deliversErrorOnBadStoreURL() async {
        let badStoreURL = cachesDirectory()
        let sut = try! FileManagerTodoStore(storeURL: badStoreURL)

        let saveError = await save(uniqueItems(), to: sut)
        XCTAssertNotNil(saveError, "Expected save error")
    }
    
    func test_save_overridesPreviouslySavedCacheValues() async {
        let sut = makeSUT()

        await save(uniqueItems(), to: sut)

        let latestItems = uniqueItems()
        await save(latestItems, to: sut)

        await expect(sut, toRetrieve: .success(CachedTodos(latestItems)))
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() async {
        let sut = makeSUT()

        let item1 = uniqueItem()
        let item2 = uniqueItem()
        await save([item1, item2], to: sut)

        let deletionError = await delete(item1 , from: sut)

        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
    }
    
    func test_delete_removesPreviouslySavedItem() async {
        let sut = makeSUT()

        let item1 = uniqueItem()
        let item2 = uniqueItem()
        await save([item1, item2], to: sut)

        await delete(item1 , from: sut)

        await expect(sut, toRetrieve: .success(CachedTodos([item2])))
    }
    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> TodoStore {
        let sut = try! FileManagerTodoStore(storeURL: testRandomStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    @discardableResult
    func save(_ item: TodoItem, to sut: TodoStore) async -> Error? {
        do {
            try await sut.save(item)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func save(_ items: [TodoItem], to sut: TodoStore) async -> Error? {
        do {
            try await sut.save(items)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func delete(_ item: TodoItem, from sut: TodoStore) async -> Error? {
        do {
            try await sut.delete(item)
            return nil
        } catch {
            return error
        }
    }
    
    func expect(_ sut: TodoStore, toRetrieveTwice expectedResult: Result<CachedTodos?, Error>, file: StaticString = #filePath, line: UInt = #line) async {
        await expect(sut, toRetrieve: expectedResult, file: file, line: line)
        await expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: TodoStore, toRetrieve expectedResult: Result<CachedTodos?, Error>, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            let receivedResult = try await sut.retrieve()
            XCTAssertEqual(receivedResult, try expectedResult.get(), file: file, line: line)
        } catch {
            XCTFail("Expected to retrieve \(expectedResult)", file: file, line: line)
        }
    }
}
