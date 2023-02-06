//
//  TodosViewControllerTests.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/5/23.
//

import Combine
import TodoEngine
import XCTest
import UIKit

final class TodosViewController: UITableViewController {
    private var loader: TodoLoader?
    
    convenience init(loader: TodoLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        Task(priority: .userInitiated) { [weak self] in
            _ = try? await self?.loader?.load()
            self?.refreshControl?.endRefreshing()
        }
    }
}

class TodosViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadTodos() {
        let (_, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsTodos() {
        let (sut, loader) = makeSUT()
        expect(sut: sut, loader: loader, loadCount: 1)
    }
    
    func test_userInitiagedReload_loadsTodos() {
        let (sut, loader) = makeSUT()
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
    
    func test_viewDidLoad_showsLoadingIndicaor() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator)
    }
    
    func test_viewDidLoad_hidesLoadingIndicaorOnLoaderCompletes() {
        let (sut, loader) = makeSUT()
        expect(sut: sut, loader: loader, isRefreshing: true)
    }
    
    func test_loadingIndicator_isVisibleWhileLoading() {
        let (sut, loader) = makeSUT()
        
        expect(sut: sut, loader: loader, loadCount: 1)
        
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected loading indicator to be hidden after view is loaded")
        
        sut.simulateUserInitiatedReload()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator to be visible after user initiates reload")
    }
    
    func test_userInitiagedReload_hidesLoadingIndicaorOnLoaderCompletes() {
        let (sut, loader) = makeSUT()
        
        let exp = expectation(description: "Wait for load to finish")
        var cancellable = Set<AnyCancellable>()
        
        loader.$loadCallCount
            .sink { if $0 == 1 { exp.fulfill() } }
            .store(in: &cancellable)
        
        sut.simulateUserInitiatedReload()
        
        wait(for: [exp], timeout: 0.1)
        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }
    
    // MARK: Helpers
    
    private func makeSUT(
        results: Result<[TodoItem], Error> = .success([]),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: TodosViewController, loader: LoaderSpy) {
        let loader = LoaderSpy(results: results)
        let sut = TodosViewController(loader: loader)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        return (sut, loader)
    }
    
    private class LoaderSpy: TodoLoader {
        private let results: Result<[TodoItem], Error>
        @Published private(set) var loadCallCount = 0
        
        init(results: Result<[TodoItem], Error>) {
            self.results = results
        }

        func load() throws -> [TodoItem] {
            loadCallCount += 1
            return try results.get()
        }
    }
    
    private func expect(
        sut: TodosViewController,
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
}

private extension TodosViewController {
    func simulateUserInitiatedReload() {
        refreshControl?.simulaterPullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
}

private extension UIRefreshControl {
    func simulaterPullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
