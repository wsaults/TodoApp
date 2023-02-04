//
//  TodoStore.swift
//  TodoEngine
//
//  Created by Will Saults on 2/4/23.
//

import Foundation

public protocol TodoStore {
    func save(_ items: [TodoItem]) throws
}
