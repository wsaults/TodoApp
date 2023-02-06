//
//  TodosViewController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import UIKit

public final class TodosViewController: UITableViewController {
    private var loader: TodoLoader?
    
    public convenience init(loader: TodoLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        Task(priority: .userInitiated) { [weak self] in
            _ = try? await self?.loader?.load()
            self?.refreshControl?.endRefreshing()
        }
    }
}
