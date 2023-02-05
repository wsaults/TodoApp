//
//  FileManagerTodoStore.swift
//  TodoEngine
//
//  Created by Will Saults on 2/5/23.
//

import Foundation

public final class FileManagerTodoStore {
    
    let storeURL: URL
    
    public init(storeURL: URL) throws {
        self.storeURL = storeURL
    }
}
