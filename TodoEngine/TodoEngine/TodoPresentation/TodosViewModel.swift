//
//  TodosViewModel.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import Foundation

public final class TodosViewModel {
    public typealias Observer<T> = (T) -> Void
    
    private let loader: TodoLoader
    private let cache: TodoCache
    
    public init(loader: TodoLoader, cache: TodoCache) {
        self.loader = loader
        self.cache = cache
    }
    
    public var onLoad: Observer<[TodoItem]>?
    public var onLoadingStateChange: Observer<Bool>?
    
    public var onSavingStateChange: Observer<Bool>?
    
    public var title: String {
        NSLocalizedString(
            "TODOS_VIEW_TITLE",
            tableName: "Todos",
            bundle: Bundle(for: TodosViewModel.self),
            comment: "Title for the tasks view")
    }
    
    public func load() {
        onLoadingStateChange?(true)
        Task(priority: .userInitiated) { @MainActor [weak self] in
            if let todos = try? await self?.loader.load() {
                self?.onLoad?(todos)
            }
            self?.onLoadingStateChange?(false)
        }
    }
    
    public func save(todo: TodoItem) {
        onSavingStateChange?(true)
        Task(priority: .userInitiated) { @MainActor [weak self] in
            try await self?.cache.save(todo)
            self?.onSavingStateChange?(false)
        }
    }
}
