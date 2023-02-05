//
//  FileManagerTodoStoreTestHelpers.swift
//  TodoEngineTests
//
//  Created by Will Saults on 2/5/23.
//

import Foundation

func testRandomStoreURL() -> URL {
    cachesDirectory().appendingPathComponent(UUID().uuidString, isDirectory: true)
}

func cachesDirectory() -> URL {
    FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
}
