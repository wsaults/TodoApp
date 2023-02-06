//
//  TodosUIComposer.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import UIKit

public final class TodosUIComposer {
    private init() {}
    
    public static func todosComposedWith(loader: TodoLoader) -> TodosViewController {
        let todosViewModel = TodosViewModel(loader: loader)
        let refreshController = TodosRefreshViewController(viewModel: todosViewModel)
        let todosController = TodosViewController(refreshController: refreshController)
        todosViewModel.onLoad = adaptTodosToCellControllers(forwardingTo: todosController, loader: loader)
        return todosController
    }
    
    private static func adaptTodosToCellControllers(forwardingTo controller: TodosViewController, loader: TodoLoader) -> ([TodoItem]) -> Void {
        { [weak controller] todos in
            controller?.tableModel = todos.map(TodoCellController.init)
        }
    }
}
