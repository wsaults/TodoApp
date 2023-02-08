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
            return try FileManagerTodoStore(storeURL: storeURL())
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
