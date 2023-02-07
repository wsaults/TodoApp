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
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    
    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    func numberOfRenderedTodos() -> Int {
        numberOfRows(in: todosSection)
    }
    
    func todoView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let index = IndexPath(row: row, section: todosSection)
        return dataSource?.tableView(tableView, cellForRowAt: index)
    }
    
    private var todosSection: Int { 0 }
}
