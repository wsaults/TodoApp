//
//  TodoPresentationTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/5/23.
//

import TodoEngine
import XCTest

public struct TodoItemViewModel {
    public let text: String?
    public let createdAt: Date?
    let completedAt: Date?

    public var isComplete: Bool {
        completedAt != nil
    }
}

public final class TodoPresenter {
    public static func map(_ item: TodoItem) -> TodoItemViewModel {
        TodoItemViewModel(
            text: item.text,
            createdAt: item.createdAt,
            completedAt: item.completedAt
        )
    }
}

class TodoPresentationTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let item = uniqueItem()
        let viewModel = TodoPresenter.map(item)
        
        XCTAssertEqual(viewModel.text, item.text)
        XCTAssertEqual(viewModel.createdAt, item.createdAt)
    }
    
    func test_map_createsNonCompletedViewModel() {
        let viewModel = TodoPresenter.map(uniqueIncompleteItem())
        
        XCTAssertFalse(viewModel.isComplete)
    }
    
    func test_map_createsCompletedViewModel() {
        let viewModel = TodoPresenter.map(uniqueItem())
        
        XCTAssertTrue(viewModel.isComplete)
    }
}
