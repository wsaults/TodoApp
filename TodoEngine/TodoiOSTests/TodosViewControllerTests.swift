//
//  TodosViewControllerTests.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/5/23.
//

import TodoEngine
import XCTest
import UIKit

final class TodosViewController: UIViewController {
    private var loader: TodoLoader?
    
    convenience init(loader: TodoLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = try? loader?.load()
    }
}

class TodosViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadTodos() {
        let loader = LoaderSpy()
        _ = TodosViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsTodos() {
        let loader = LoaderSpy()
        let sut = TodosViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // MARK: Helpers
    
    class LoaderSpy: TodoLoader {
        private(set) var loadCallCount = 0

        func load() throws -> [TodoItem] {
            loadCallCount += 1
            return []
        }
    }
}
