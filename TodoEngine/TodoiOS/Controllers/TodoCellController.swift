//
//  TodoCellController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import UIKit

public final class TodoCellController {
    private let viewModel: TodoItemViewModel
    
    public init(viewModel: TodoItemViewModel) {
        self.viewModel = viewModel
    }
    
    func view(for tableView: UITableView) -> UITableViewCell {
        binded(tableView.dequeueReusableCell())
    }
    
    private func binded(_ cell: TodoCell) -> TodoCell {
        cell.taskLabel.text = viewModel.text
        cell.setCompleted(isComplete: viewModel.isComplete)
        return cell
    }
}
