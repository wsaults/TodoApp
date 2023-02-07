//
//  SceneDelegate.swift
//  TodoApp
//
//  Created by Will Saults on 2/6/23.
//

import UIKit
import TodoEngine
import TodoiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        do {
            let store = try FileManagerTodoStore(storeURL: fileURL())
            let loader = LocalTodoLoader(store: store)
            let todosViewController = TodosUIComposer.todosComposedWith(loader: loader)
            
            window?.rootViewController = todosViewController
        } catch {
            print("Error \(error)")
        }
    }
    
    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("todos.store")
    }
}

