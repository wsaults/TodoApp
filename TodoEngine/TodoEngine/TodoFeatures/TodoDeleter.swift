//
//  TodoDeleter.swift
//  TodoEngine
//
//  Created by Will Saults on 2/8/23.
//

import Foundation

public protocol TodoDeleter {
    func delete(_ item: TodoItem) async throws
}
