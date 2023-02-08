//
//  SceneDelegate.swift
//  TodoApp
//
//  Created by Will Saults on 2/6/23.
//

import os
import UIKit
import TodoEngine
import TodoiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var logger = Logger(subsystem: "com.Saults.TodoApp", category: "main")
    
    private lazy var store: TodoStore = {
        do {
            return InMemoryTodoStore.withTodosCache
//            return try FileManagerTodoStore(storeURL: storeURL())
        } catch {
            assertionFailure("Failed to instantiate store with error: \(error.localizedDescription)")
            logger.fault("Failed to instantiate store with error: \(error.localizedDescription)")
            return NullStore()
        }
    }()
    
    private lazy var localLoader: LocalTodoLoader = {
        LocalTodoLoader(store: store)
    }()
    
    private lazy var navigationController = UINavigationController(
        rootViewController: TodosUIComposer.todosComposedWith(
            loader: localLoader,
            cache: localLoader
        )
    )
    
    convenience init(store: TodoStore) {
        self.init()
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func storeURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("todos.store")
    }
}

class InMemoryTodoStore {
    private(set) var todoCache = CachedTodos()
    
    private init(todoCache: CachedTodos) {
        self.todoCache = todoCache
    }
}

// TODO: Remove this helper
extension InMemoryTodoStore: TodoStore {
    func save(_ items: [TodoItem]) async throws {
        todoCache = CachedTodos(items)
    }
    
    func save(_ item: TodoItem) async throws {
        todoCache.removeAll { $0.uuid == item.uuid }
        todoCache.append(item)
    }
    
    func retrieve() async throws -> CachedTodos {
        todoCache
    }
    
    func delete(_ item: TodoItem) async throws {
        todoCache = []
    }
}

extension InMemoryTodoStore {
    static var empty: InMemoryTodoStore {
        InMemoryTodoStore(todoCache: CachedTodos([]))
    }
    
    static var withTodosCache: InMemoryTodoStore {
        InMemoryTodoStore(todoCache: CachedTodos([
            TodoItem(uuid: UUID(), text: "Todo one", createdAt: Date.now),
            TodoItem(uuid: UUID(), text: "Todo two", createdAt: Date.now, completedAt: Date.now)
        ]))
    }
}
