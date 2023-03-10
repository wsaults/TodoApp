//
//  TodoCellController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import UIKit

public protocol TodoCellControllerDelegate: AnyObject {
    func didChange(viewModel: TodoItemViewModel, shouldNotify: Bool)
    func didDelete(viewModel: TodoItemViewModel)
}

public final class TodoCellController {
    private let placeholderProvider: TodoPlaceholderProvidable
    private var viewModel: TodoItemViewModel
    weak var delegate: TodoCellControllerDelegate?
    var cellContentListener: (() -> Void)?
    
    public init(viewModel: TodoItemViewModel, placeholderProvider: TodoPlaceholderProvidable) {
        self.viewModel = viewModel
        self.placeholderProvider = placeholderProvider
    }
    
    func view(for tableView: UITableView) -> UITableViewCell {
        binded(tableView.dequeueReusableCell())
    }
    
    private func binded(_ cell: TodoCell) -> TodoCell {
        cell.taskTextView.text = viewModel.text
        cell.placeholderTextField.placeholder = placeholderProvider.placeholder()
        cell.hidePlaceholderField(!viewModel.text.isEmpty)
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
            delegate?.didChange(viewModel: updatedViewModel, shouldNotify: true)
        }
    }
    
    public func isUpdatingContent(_ text: String) {
        viewModel.text = text
        delegate?.didChange(viewModel: viewModel, shouldNotify: false)
    }
    
    public func shouldUpdateUI() {
        cellContentListener?()
    }
    
    public func didDelete() {
        delegate?.didDelete(viewModel: viewModel)
    }
}
