//
//  FileManagerTodoStoreTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/4/23.
//

import TodoEngine
import XCTest

class FileManagerTodoStore {
    
    private let storeURL: URL
    
    public init(storeURL: URL) throws {
        self.storeURL = storeURL
    }
}

extension FileManagerTodoStore: TodoStore {
    
    public func save(_ items: [TodoItem]) throws {
        let data = try JSONEncoder().encode(items)
        let outfile = self.storeURL
        try data.write(to: outfile)
    }
    
    public func retrieve() throws -> CachedTodos? {
        let fileURL = self.storeURL
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
            return nil
        }
        return try JSONDecoder().decode(CachedTodos.self, from: file.availableData)
    }
    
    public func delete(_ item: TodoItem) throws {}
}

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
