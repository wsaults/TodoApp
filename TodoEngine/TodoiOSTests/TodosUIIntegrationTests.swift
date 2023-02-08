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
@testable import TodoiOS

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
        expect(sut, loader: loader, loadCount: 1, isRefreshing: false)
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
        sut.loadViewIfNeeded()
        
        expect(loader: loader, loadCount: 2) {
            sut.simulateUserInitiatedReload()
        } assertion: {
            XCTAssertFalse(sut.isShowingLoadingIndicator)
        }
    }
    
    func test_userInitiatedReload_hidesLoadingIndicaorOnLoaderError() {
        let (sut, loader) = makeSUT(results: [emptySuccess, anyFailure])
        sut.loadViewIfNeeded()
        
        expect(loader: loader, loadCount: 2) {
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
        
        expect(loader: loader, loadCount: 1)  {
            sut.loadViewIfNeeded()
        } assertion: {
            assertThat(sut, isRendering: [todo0, todo1, todo2, todo3])
        }
    }
    
    func test_loadCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let todo0 = makeTodo(text: "a text", createdAt: Date.now)
        let (sut, loader) = makeSUT(results: [.success([todo0]), anyFailure])
        
        expect(loader: loader, loadCount: 1) {
            sut.loadViewIfNeeded()
        } assertion: {
            assertThat(sut, isRendering: [todo0])
        }
        
        expect(loader: loader, loadCount: 2) {
            sut.simulateUserInitiatedReload()
        } assertion: {
            assertThat(sut, isRendering: [todo0])
        }
    }
    
    func test_tappingCompleteAction_completesTodo() {
        let todo0 = makeTodo(text: "a text", createdAt: Date.now)
        let (sut, loader) = makeSUT(results: [.success([todo0])])
        
        expect(loader: loader, loadCount: 1)  {
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
        
        expect(cache: cache, saveCount: 1) {
            sut.loadViewIfNeeded()
            sut.addButton.simulateTap()
        } assertion: {
            XCTAssertEqual(cache.saveCallCount, 1)
        }
    }
    
    func test_tappingDelete_removesTodo() {
        let todo0 = makeTodo(text: "a text", createdAt: Date.now)
        let (sut, loader, deleter) = makeSUTWithDeleter(results: [.success([todo0])])
        
        expect(loader: loader, loadCount: 1)  {
            sut.loadViewIfNeeded()
        } assertion: {
            expect(deleter: deleter, deleteCount: 1) {
                let cell = sut.todoView(at: 0)
                cell?.simulateDeleteAction()
            } assertion: {
                XCTAssertEqual(deleter.deleteCallCount, 1)
            }
        }
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
        let sut = TodosUIComposer.todosComposedWith(loader: loader, cache: CacheSpy(), deleter: DeleterSpy())
        
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
        let sut = TodosUIComposer.todosComposedWith(loader: loader, cache: cache, deleter: DeleterSpy())
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(cache, file: file, line: line)
        
        return (sut, loader, cache)
    }
    
    private func makeSUTWithDeleter(
        results: [Result<[TodoItem], Error>] = [.success([])],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        sut: TodosViewController,
        loader: LoaderSpy,
        cache: DeleterSpy
    ) {
        let loader = LoaderSpy(results: results)
        let deleter = DeleterSpy()
        let sut = TodosUIComposer.todosComposedWith(loader: loader, cache: CacheSpy(), deleter: deleter)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(deleter, file: file, line: line)
        
        return (sut, loader, deleter)
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
        @Published private(set) var saveCallCount = 0
        
        func save(_ items: [TodoEngine.TodoItem]) async throws {}
        
        func save(_ item: TodoEngine.TodoItem) async throws {
            saveCallCount += 1
        }
    }
    
    private class DeleterSpy: TodoDeleter {
        @Published private(set) var deleteCallCount = 0
        
        func delete(_ item: TodoEngine.TodoItem) async throws {
            deleteCallCount += 1
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
            .receive(on: DispatchQueue.main)
            .sink { if $0 >= loadCount { exp.fulfill() } }
            .store(in: &cancellable)
        
        sut.loadViewIfNeeded()
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(loader.loadCallCount, loadCount, file: file, line: line)
        XCTAssertEqual(sut.isShowingLoadingIndicator, isRefreshing, file: file, line: line)
    }
    
    private func expect(
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
            .receive(on: DispatchQueue.main)
            .sink { if $0 >= loadCount { exp.fulfill() } }
            .store(in: &cancellable)
        action()
        wait(for: [exp], timeout: 0.1)
        assertion()
    }
    
    private func expect(
        cache: CacheSpy,
        saveCount: Int = 0,
        action: () -> Void,
        assertion: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for save to finish")
        var cancellable = Set<AnyCancellable>()
        cache.$saveCallCount
            .receive(on: DispatchQueue.main)
            .sink { if $0 >= saveCount { exp.fulfill() } }
            .store(in: &cancellable)
        action()
        wait(for: [exp], timeout: 0.1)
        
        assertion()
    }
    
    private func expect(
        deleter: DeleterSpy,
        deleteCount: Int = 0,
        action: () -> Void,
        assertion: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for delete to finish")
        var cancellable = Set<AnyCancellable>()
        deleter.$deleteCallCount
            .receive(on: DispatchQueue.main)
            .sink { if $0 >= deleteCount { exp.fulfill() } }
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
