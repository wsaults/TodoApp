//
//  TodosViewController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import UIKit

public final class TodosViewController: UITableViewController {
    private var refreshController: TodosRefreshViewController?
    var tableModel = [TodoCellController]() {
        didSet { reloadData() }
    }
    
    convenience init(refreshController: TodosRefreshViewController) {
        self.init()
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = refreshController?.view
        
        refreshController?.refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view()
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> TodoCellController {
        tableModel[indexPath.row]
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
}
