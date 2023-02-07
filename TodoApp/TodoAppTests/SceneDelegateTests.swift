//
//  SceneDelegateTests.swift
//  TodoAppTests
//
//  Created by Will Saults on 2/7/23.
//

import XCTest
import TodoiOS
@testable import TodoApp

class SceneDelegateTests: XCTestCase {
    
    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window
        sut.configureWindow()
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected to make window key and visible")
    }
    
    func test_configureWindow_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindow()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigtion controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is TodosViewController, "Expected a todos controller as top view controller, got \(String(describing: topController)) instead")
    }
    
    // MARK: Helpers
    
    private class UIWindowSpy: UIWindow {
        var makeKeyAndVisibleCallCount = 0
        override func makeKeyAndVisible() {
            makeKeyAndVisibleCallCount = 1
        }
    }
}
