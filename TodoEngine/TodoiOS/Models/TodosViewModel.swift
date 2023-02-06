//
//  TodosViewModel.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import UIKit

public final class TodosViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let loader: TodoLoader
    
    public init(loader: TodoLoader) {
        self.loader = loader
    }
    
    var onLoad: Observer<[TodoItem]>?
    var onLoadingStateChange: Observer<Bool>?
    
    func load() {
        onLoadingStateChange?(true)
        Task(priority: .userInitiated) { @MainActor [weak self] in
            if let todos = try? await self?.loader.load() {
                self?.onLoad?(todos)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
