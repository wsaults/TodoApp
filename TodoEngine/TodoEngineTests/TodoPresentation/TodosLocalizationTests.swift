//
//  TodosLocalizationTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/5/23.
//

import TodoEngine
import XCTest

final class TodosLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Todos"
        let bundle = Bundle(for: TodosPresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
