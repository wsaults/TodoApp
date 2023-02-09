//
//  TodoPlaceholderProvider.swift
//  TodoEngine
//
//  Created by Will Saults on 2/9/23.
//

import Foundation

public protocol TodoPlaceholderProvidable {
    func placeholder() -> String
}

public final class TodoPlaceholderProvider: TodoPlaceholderProvidable {
    
    private let placeholders: [String]
    
    public init(placeholders: [String]) {
        self.placeholders = placeholders
    }
    
    public func placeholder() -> String {
        placeholders.randomElement() ?? ""
    }
}
