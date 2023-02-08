//
//  TodoCellController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import UIKit

public protocol TodoCellControllerDelegate {
    func didChange(viewModel: TodoItemViewModel)
}

public final class TodoCellController {
    private let viewModel: TodoItemViewModel
    private let delegate: TodoCellControllerDelegate
    
    public init(viewModel: TodoItemViewModel, delegate: TodoCellControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    func view(for tableView: UITableView) -> UITableViewCell {
        binded(tableView.dequeueReusableCell())
    }
    
    private func binded(_ cell: TodoCell) -> TodoCell {
        cell.taskLabel.text = viewModel.text
        cell.setCompleted(isComplete: viewModel.isComplete)
        cell.delegate = self
        return cell
    }
}

extension TodoCellController: TodoCellDelegate {    
    public func cellDidUpdate() {
        delegate.didChange(viewModel: viewModel)
    }
}
