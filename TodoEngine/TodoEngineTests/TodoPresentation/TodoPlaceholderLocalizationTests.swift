//
//  TodoPlaceholderLocalizationTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/9/23.
//

import TodoEngine
import XCTest

final class TodoPlaceholderLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "TodoPlaceholder"
        let bundle = Bundle(for: TodoPlaceholderProvider.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
