//
//  TodosViewControllerTests.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/5/23.
//

import XCTest

final class TodosViewController {
    init(loader: TodosViewControllerTests.LoaderSpy) {
        
    }
}

class TodosViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadTodos() {
        let loader = LoaderSpy()
        _ = TodosViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: Helpers
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
