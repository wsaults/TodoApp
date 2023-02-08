//
//  TodosUIIntegrationTests.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/5/23.
//

import Combine
import TodoEngine
import XCTest
import UIKit

class TodosUIIntegrationTests: XCTestCase {
    
    func test_init_doesNotLoadTodos() {
        let (_, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsTodos() {
        let (sut, loader) = makeSUT()
        expect(sut, loader: loader, loadCount: 1)
    }
    
    func test_userInitiatedReload_loadsTodos() {
        let (sut, loader) = makeSUT(results: [emptySuccess, emptySuccess, emptySuccess])
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for second load to finish")
        let exp2 = expectation(description: "Wait for third load to finish")
        var cancellable = Set<AnyCancellable>()
        
        loader.$loadCallCount
            .sink {
                if $0 == 2 { exp.fulfill() }
                if $0 == 3 { exp2.fulfill() }
            }
            .store(in: &cancellable)
        
        sut.simulateUserInitiatedReload()
        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.simulateUserInitiatedReload()
        wait(for: [exp2], timeout: 0.1)
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    func test_todsView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, localized("TODOS_VIEW_TITLE"))
    }
    
    func test_viewDidLoad_showsLoadingIndicaor() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator)
    }
    
    func test_viewDidLoad_hidesLoadingIndicaorOnLoaderCompletes() {
        let (sut, loader) = makeSUT()
        expect(sut, loader: loader, isRefreshing: true)
    }
    
    func test_loadingIndicator_isVisibleWhileLoading() {
        let (sut, loader) = makeSUT()
        
        expect(sut, loader: loader, loadCount: 1)
        
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected loading indicator to be hidden after view is loaded")
        
        sut.simulateUserInitiatedReload()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator to be visible after user initiates reload")
    }
    
    func test_userInitiatedReload_hidesLoadingIndicaorOnLoaderCompletes() {
        let (sut, loader) = makeSUT(results: [emptySuccess, emptySuccess])
        
        expect(sut, loader: loader, loadCount: 2) {
            sut.simulateUserInitiatedReload()
        } assertion: {
            XCTAssertFalse(sut.isShowingLoadingIndicator)
        }
    }
    
    func test_userInitiatedReload_hidesLoadingIndicaorOnLoaderError() {
        let (sut, loader) = makeSUT(results: [emptySuccess, anyFailure])
        
        expect(sut, loader: loader, loadCount: 2) {
            sut.simulateUserInitiatedReload()
        } assertion: {
            XCTAssertFalse(sut.isShowingLoadingIndicator)
        }
    }
    
    func test_init_rendersNoTodos() {
        let (sut, _) = makeSUT()
        
        assertThat(sut, isRendering: [])
    }
    
    func test_loadCompletion_rendersTodos() {
        let todo0 = makeTodo(text: "a text", createdAt: Date.now)
        let todo1 = makeTodo(text: "a second text", createdAt: Date.now)
        let todo2 = makeTodo(text: "a third text", createdAt: Date.now)
        let todo3 = makeTodo(text: "a fourth text", createdAt: Date.now)
        let (sut, loader) = makeSUT(results: [.success([todo0, todo1, todo2, todo3])])
        
        expect(sut, loader: loader, loadCount: 1)  {
            sut.loadViewIfNeeded()
        } assertion: {
            assertThat(sut, isRendering: [todo0, todo1, todo2, todo3])
        }
    }
    
    func test_loadCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let todo0 = makeTodo(text: "a text", createdAt: Date.now)
        let (sut, loader) = makeSUT(results: [.success([todo0]), anyFailure])
        
        expect(sut, loader: loader, loadCount: 1) {
            sut.loadViewIfNeeded()
        } assertion: {
            assertThat(sut, isRendering: [todo0])
        }
        
        expect(sut, loader: loader, loadCount: 2) {
            sut.simulateUserInitiatedReload()
        } assertion: {
            assertThat(sut, isRendering: [todo0])
        }
    }
    
    func test_tappingCompleteAction_completesTodo() {
        let todo0 = makeTodo(text: "a text", createdAt: Date.now)
        let (sut, loader) = makeSUT(results: [.success([todo0])])
        
        expect(sut, loader: loader, loadCount: 1)  {
            sut.loadViewIfNeeded()
        } assertion: {
            let cell = sut.todoView(at: 0)
            XCTAssertEqual(cell?.radioButton.isSelected, false)
            cell?.simulateCompleteAction()
            XCTAssertEqual(cell?.radioButton.isSelected, true)
        }
    }
    
    func test_tappingAdd_createsEmptyTodo() {
        let (sut, _, cache) = makeSUTWithCache()
        sut.loadViewIfNeeded()
        
        sut.addButton.simulateTap()
        
        XCTAssertEqual(cache.saveCallCount, 1)
    }
    
    // MARK: Helpers
    
    private let emptySuccess: Result<[TodoItem], Error> = .success([])
    private let anyFailure: Result<[TodoItem], Error> = .failure(anyNSError)
    
    private func makeSUT(
        results: [Result<[TodoItem], Error>] = [.success([])],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        sut: TodosViewController,
        loader: LoaderSpy
    ) {
        let loader = LoaderSpy(results: results)
        let sut = TodosUIComposer.todosComposedWith(loader: loader, cache: CacheSpy())
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        return (sut, loader)
    }
    
    private func makeSUTWithCache(
        results: [Result<[TodoItem], Error>] = [.success([])],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        sut: TodosViewController,
        loader: LoaderSpy,
        cache: CacheSpy
    ) {
        let loader = LoaderSpy(results: results)
        let cache = CacheSpy()
        let sut = TodosUIComposer.todosComposedWith(loader: loader, cache: cache)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(cache, file: file, line: line)
        
        return (sut, loader, cache)
    }
    
    private class LoaderSpy: TodoLoader {
        private var results = [Result<[TodoItem], Error>]()
        @Published private(set) var loadCallCount = 0
        
        init(results: [Result<[TodoItem], Error>]) {
            self.results = results
        }

        func load() throws -> [TodoItem] {
            loadCallCount += 1
            return try results.removeFirst().get()
        }
    }
    
    private class CacheSpy: TodoCache {
        @Published private(set) var saveItemsCallCount = 0
        @Published private(set) var saveCallCount = 0
        
        func save(_ items: [TodoEngine.TodoItem]) async throws {
            saveItemsCallCount += 1
        }
        
        func save(_ item: TodoEngine.TodoItem) async throws {
            saveCallCount += 1
        }
    }
    
    private func makeTodo(text: String, createdAt: Date) -> TodoItem {
        TodoItem(uuid: UUID(), text: text, createdAt: createdAt)
    }
    
    private func expect(
        _ sut: TodosViewController,
        loader: LoaderSpy,
        loadCount: Int = 0,
        isRefreshing: Bool = false,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load to finish")
        var cancellable = Set<AnyCancellable>()
        
        loader.$loadCallCount
            .sink { if $0 >= loadCount { exp.fulfill() } }
            .store(in: &cancellable)
        
        sut.loadViewIfNeeded()
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(loader.loadCallCount, loadCount, file: file, line: line)
        XCTAssertEqual(sut.isShowingLoadingIndicator, isRefreshing, file: file, line: line)
    }
    
    private func expect(
        _ sut: TodosViewController,
        loader: LoaderSpy,
        loadCount: Int = 0,
        action: () -> Void,
        assertion: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load to finish")
        var cancellable = Set<AnyCancellable>()
        
        loader.$loadCallCount
            .sink {
                if $0 >= loadCount { exp.fulfill() }
            }
            .store(in: &cancellable)
        
        action()
        
        wait(for: [exp], timeout: 0.1)
        
        assertion()
    }
    
    private func assertThat(
        _ sut: TodosViewController,
        isRendering todos: [TodoItem],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard sut.numberOfRenderedTodos() == todos.count else {
            return XCTFail("Expected \(todos.count) todos, got \(sut.numberOfRenderedTodos()) instead.", file: file, line: line)
        }
        
        todos.enumerated().forEach { index, todo in
            assertThat(sut, hasViewConfiguredFor: todo, at: index)
        }
    }
    
    private func assertThat(
        _ sut: TodosViewController,
        hasViewConfiguredFor todo: TodoItem,
        at row: Int,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let view = sut.todoView(at: row)
        
        XCTAssertNotNil(view, "Expected \(TodoCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        XCTAssertEqual(view?.taskText, todo.text, file: file, line: line)
        XCTAssertNotNil(view?.radioButton, file: file, line: line)
        XCTAssertEqual(view?.radioButton.isSelected, todo.completedAt != nil, file: file, line: line)
    }
}

let anyNSError = NSError(domain: "any error", code: 0)
