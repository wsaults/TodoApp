//
//  TodosUIIntegrationTests+Localization.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/6/23.
//

import XCTest
import TodoEngine

extension TodosUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Todos"
        let bundle = Bundle(for: TodosViewModel.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
