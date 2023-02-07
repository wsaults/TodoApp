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
        XCTAssertEqual(TodosPresenter.title, localized("TODOS_VIEW_TITLE"))
    }
    
    // MARK: Helpers

    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Todos"
        let bundle = Bundle(for: TodosPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
