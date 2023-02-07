//
//  TodoCellController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import UIKit

public final class TodoCellController {
    private let viewModel: TodoItem
    
    public init(viewModel: TodoItem) {
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
