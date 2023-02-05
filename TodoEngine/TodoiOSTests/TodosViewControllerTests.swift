//
//  TodosViewControllerTests.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/5/23.
//

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
        _ = try? loader?.load()
    }
}

class TodosViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadTodos() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsTodos() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_pullToRefresh_loadsTodos() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.refreshControl?.simulaterPullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.refreshControl?.simulaterPullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    // MARK: Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: TodosViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = TodosViewController(loader: loader)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        return (sut, loader)
    }
    
    private class LoaderSpy: TodoLoader {
        private(set) var loadCallCount = 0

        func load() throws -> [TodoItem] {
            loadCallCount += 1
            return []
        }
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
