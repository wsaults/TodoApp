//
//  TodoAcceptanceTests.swift
//  TodoAppTests
//
//  Created by Will Saults on 2/7/23.
//

@testable import TodoApp
import TodoEngine
import TodoiOS
import XCTest

class TodoAcceptanceTests: XCTestCase {
    
    func test_onLaunch_displaysNoTodosOnEmptyCache() {
        let todos = launch(store: .empty)
        
        XCTAssertEqual(todos.numberOfRenderedTodos(), 0)
    }
    
    // MARK: - Helpers
    
    private func launch(
        store: InMemoryTodoStore = .empty
    ) -> TodosViewController {
        let sut = SceneDelegate(store: store)
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! TodosViewController
    }
}

extension TodosViewController {
    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    func numberOfRenderedTodos() -> Int {
        numberOfRows(in: todosSection)
    }
    
    private var todosSection: Int { 0 }
}
