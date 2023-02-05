//
//  TodosViewControllerTests.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/5/23.
//

import XCTest
import UIKit

final class TodosViewController: UIViewController {
    private var loader: TodosViewControllerTests.LoaderSpy?
    
    convenience init(loader: TodosViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load()
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
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
        
        func load() {
            loadCallCount += 1
        }
    }
}
