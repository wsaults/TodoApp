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
    private let deleter: TodoDeleter
    
    public init(loader: TodoLoader, cache: TodoCache, deleter: TodoDeleter) {
        self.loader = loader
        self.cache = cache
        self.deleter = deleter
    }
    
    public var onLoad: Observer<[TodoItem]>?
    public var onLoadingStateChange: Observer<Bool>?
    public var onSavingStateChange: Observer<Bool>?
    public var onDeletionStateChange: Observer<Bool>?
    
    public var title: String {
        NSLocalizedString(
            "TODOS_VIEW_TITLE",
            tableName: "Todos",
            bundle: Bundle(for: TodosViewModel.self),
            comment: "Title for the tasks view")
    }
    
    public func load(withStateChange: Bool = true) {
        if withStateChange {
            onLoadingStateChange?(true)
        }
        Task(priority: .userInitiated) { @MainActor [weak self] in
            if let todos = try? await self?.loader.load() {
                self?.onLoad?(todos)
            }
            if withStateChange {
                self?.onLoadingStateChange?(false)
            }
        }
    }
    
    public func save(todo: TodoItem) {
        onSavingStateChange?(true)
        Task(priority: .userInitiated) { @MainActor [weak self] in
            try await self?.cache.save(todo)
            self?.onSavingStateChange?(false)
        }
    }
    
    public func delete(todo: TodoItem) {
        onDeletionStateChange?(true)
        Task(priority: .userInitiated) { @MainActor [weak self] in
            try await self?.deleter.delete(todo)
            self?.onDeletionStateChange?(false)
        }
    }
}
