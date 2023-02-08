//
//  TodosUIComposer.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import TodoiOS
import UIKit

public final class TodosUIComposer {
    private init() {}
    
    public static func todosComposedWith(
        loader: TodoLoader,
        cache: TodoCache
    ) -> TodosViewController {
        let todosViewModel = TodosViewModel(loader: loader)
        let todosCacheController = TodosCacheController(cache: cache)
        let refreshController = TodosRefreshViewController(viewModel: todosViewModel)
        let todosController = TodosViewController.makeWith(refreshController: refreshController, title: todosViewModel.title)
        
        todosViewModel.onLoad = adaptTodosToCellControllers(forwardingTo: todosController, with: todosCacheController)
        return todosController
    }
    
    private static func adaptTodosToCellControllers(
        forwardingTo controller: TodosViewController,
        with delegate: TodoCellControllerDelegate
    ) -> ([TodoItem]) -> Void {
        { [weak controller] todos in
            controller?.tableModel = todos.map {
                TodoCellController(viewModel: TodoPresenter.map($0), delegate: delegate)
            }
        }
    }
}

private extension TodosViewController {
    static func makeWith(refreshController: TodosRefreshViewController, title: String) -> TodosViewController {
        let todosController = TodosViewController(refreshController: refreshController)
        todosController.title = title
        return todosController
    }
}

extension TodosCacheController: TodoCellControllerDelegate {
    public func didChange(viewModel: TodoItemViewModel) {
        save(todo: TodoPresenter.map(viewModel))
    }
}
