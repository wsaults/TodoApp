//
//  TodoCellController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import UIKit

final class TodoCellController {
    private let viewModel: TodoItem
    
    init(viewModel: TodoItem) {
        self.viewModel = viewModel
    }
    
    func view() -> UITableViewCell {
        binded(TodoCell())
    }
    
    private func binded(_ cell: TodoCell) -> TodoCell {
        cell.taskLabel.text = viewModel.text
        return cell
    }
}
