//
//  TodoLoader.swift
//  TodoEngine
//
//  Created by Will Saults on 2/5/23.
//

import Foundation

public protocol TodoLoader {
    func load() throws -> [TodoItem]
}
