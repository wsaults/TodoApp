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
    public let completedAt: String?

    public var isComplete: Bool {
        completedAt != nil
    }
}

public final class TodoPresenter {
    public static func map(_ item: TodoItem) -> TodoItemViewModel {
        var completedValue: String?
        if let completedAt = item.completedAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            completedValue = dateFormatter.string(from: completedAt)
        }
        
        return TodoItemViewModel(
            text: item.text,
            completedAt: completedValue
        )
    }
}

class TodoPresentationTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let item = uniqueItem()
        let viewModel = TodoPresenter.map(item)
        
        XCTAssertEqual(viewModel.text, item.text)
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
