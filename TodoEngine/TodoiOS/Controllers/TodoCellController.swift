//
//  TodoCellController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import UIKit

public protocol TodoCellControllerDelegate: AnyObject {
    func didChange(viewModel: TodoItemViewModel)
    func didDelete(viewModel: TodoItemViewModel)
}

public final class TodoCellController {
    private let viewModel: TodoItemViewModel
    weak var delegate: TodoCellControllerDelegate?
    
    public init(viewModel: TodoItemViewModel) {
        self.viewModel = viewModel
    }
    
    func view(for tableView: UITableView) -> UITableViewCell {
        binded(tableView.dequeueReusableCell())
    }
    
    private func binded(_ cell: TodoCell) -> TodoCell {
        cell.taskField.text = viewModel.text
        cell.setCompleted(isComplete: viewModel.isComplete)
        cell.delegate = self
        return cell
    }
}

extension TodoCellController: TodoCellDelegate {    
    public func didUpdate(text: String, isComplete: Bool) {
        let updatedViewModel = TodoItemViewModel(
            uuid: viewModel.uuid,
            text: text,
            createdAt: viewModel.createdAt,
            completedAt: isComplete ? Date.now : nil
        )
        if updatedViewModel != viewModel {
            delegate?.didChange(viewModel: updatedViewModel)
        }
    }
    
    public func didDelete() {
        delegate?.didDelete(viewModel: viewModel)
    }
}
