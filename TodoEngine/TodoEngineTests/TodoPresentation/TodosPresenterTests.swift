//
//  TodosPresenterTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/5/23.
//

import TodoEngine
import XCTest

class TodosPresenterTests: XCTestCase {
    
    func test_hasTitle() {
        XCTAssertEqual(TodosPresenter.title, "Tasks")
    }
}
