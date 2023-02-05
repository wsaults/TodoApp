//
//  TodoPresentationTests.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/5/23.
//

import TodoEngine
import XCTest

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
