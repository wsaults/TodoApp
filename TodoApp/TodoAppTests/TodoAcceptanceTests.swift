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
    
    func test_onLaunch_displaysTodosFromNonEmptyCache() {
        let todos = launch(store: .withTodosCache)
        
        var numberOfRenderedTodos = todos.numberOfRenderedTodos()
        let exp = XCTestExpectation(description: "Wait for todos")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            numberOfRenderedTodos = todos.numberOfRenderedTodos()
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.2)
        XCTAssertEqual(numberOfRenderedTodos, 2)
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
