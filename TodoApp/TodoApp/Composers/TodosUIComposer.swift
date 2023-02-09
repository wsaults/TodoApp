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
    
    public static func todosComposedWith(
        loader: TodoLoader,
        cache: TodoCache,
        deleter: TodoDeleter
    ) -> TodosViewController {
        let todosViewModel = TodosViewModel(loader: loader, cache: cache, deleter: deleter)
        let refreshController = TodosRefreshViewController(viewModel: todosViewModel)
        let todosController = TodosViewController.makeWith(
            refreshController: refreshController,
            delegate: todosViewModel,
            title: todosViewModel.title,
            emptyStateText: todosViewModel.emptyStateText
        )
        
        todosViewModel.onLoad = adaptTodosToCellControllers(forwardingTo: todosController)
        return todosController
    }
    
    private static func adaptTodosToCellControllers(forwardingTo controller: TodosViewController) -> ([TodoItem]) -> Void {
        { [weak controller] todos in
            controller?.tableModel = todos.map {
                TodoCellController(viewModel: TodoPresenter.map($0))
            }
        }
    }
}

private extension TodosViewController {
    static func makeWith(
        refreshController: TodosRefreshViewController,
        delegate: TodosCacheController,
        title: String,
        emptyStateText: String
    ) -> TodosViewController {
        let todosController = TodosViewController(refreshController: refreshController, delegate: delegate)
        todosController.title = title
        todosController.noTodosLabel.text = emptyStateText
        return todosController
    }
}

extension TodosViewModel: TodoCellControllerDelegate {
    public func didChange(viewModel: TodoItemViewModel, shouldNotify: Bool) {
        save(todo: TodoPresenter.map(viewModel), shouldNotify: shouldNotify)
    }
    
    public func didDelete(viewModel: TodoItemViewModel) {
        delete(todo: TodoPresenter.map(viewModel))
    }
}

extension TodosViewModel: TodosViewControllerCachingDelegate {
    public func didAdd() {
        save(todo: TodoItem(uuid: UUID(), text: "", createdAt: Date.now), shouldNotify: true)
    }
}
