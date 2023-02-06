//
//  TodoCache.swift
//  TodoEngine
//
//  Created by Will Saults on 2/4/23.
//

import Foundation

public protocol TodoCache {
    func save(_ items: [TodoItem]) async throws
}
