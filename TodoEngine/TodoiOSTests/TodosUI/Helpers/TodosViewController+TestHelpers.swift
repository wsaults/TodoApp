//
//  TodosViewController+TestHelpers.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/6/23.
//

import TodoiOS
import UIKit

extension TodosViewController {
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    
    func numberOfRenderedTodos() -> Int {
        tableView.numberOfRows(inSection: todosSection)
    }
    
    func todoView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let index = IndexPath(row: row, section: todosSection)
        return dataSource?.tableView(tableView, cellForRowAt: index)
    }
    
    private var todosSection: Int {
        0
    }
}
