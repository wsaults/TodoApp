//
//  TodosViewController+TestHelpers.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/6/23.
//

import TodoiOS
import UIKit

extension TodosViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        tableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    func simulateUserInitiatedReload() {
        tableView.refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        tableView.refreshControl?.isRefreshing == true
    }
    
    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    func numberOfRenderedTodos() -> Int {
        numberOfRows(in: todosSection)
    }
    
    func cell(at row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }
        let dataSource = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return dataSource?.tableView(tableView, cellForRowAt: index)
    }
    
    func todoView(at row: Int) -> TodoCell? {
        cell(at: row, section: todosSection) as? TodoCell
    }
    
    private var todosSection: Int { 0 }
}

extension TodosViewController {
    
    @discardableResult
    func simulateTodoVisible(at index: Int) -> TodoCell? {
        todoView(at: index)
    }
}
