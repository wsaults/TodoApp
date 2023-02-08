//
//  TodosViewController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import UIKit

public protocol TodosViewControllerDelegate: AnyObject {
    func didAdd()
}

public final class TodosViewController: UIViewController {
    public typealias TodosCacheController = (TodosViewControllerDelegate & TodoCellControllerDelegate)
    
    private enum Constants {
        static let horizontalMargin = 40.0
        static let addButtonHeight = 60.0
        static let addButtonImageName = "plus"
    }
    
    private var refreshController: TodosRefreshViewController?
    weak var delegate: TodosCacheController?
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TodoCell.self)
        tableView.refreshControl = refreshController?.view
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    public var tableModel = [TodoCellController]() {
        didSet { reloadData() }
    }
    
    public lazy var addButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .blue
        configuration.cornerStyle = .capsule
        
        configuration.image = UIImage(
            systemName: Constants.addButtonImageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.addButtonHeight / 2, weight: .bold, scale: .large))
        let action = UIAction(handler: { [weak self] _ in self?.addButtonTapped() })
        let button = UIButton(configuration: configuration, primaryAction: action)
        return button
    }()
    
    private func addButtonTapped() {
        delegate?.didAdd()
    }
    
    public convenience init(
        refreshController: TodosRefreshViewController,
        delegate: TodosCacheController
    ) {
        self.init()
        self.refreshController = refreshController
        self.delegate = delegate
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setConstraints()
        
        refreshController?.refresh()
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
    
    private func addViews() {
        view.addSubview(tableView)
        view.addSubview(addButton)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> TodoCellController {
        tableModel[indexPath.row]
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.horizontalMargin),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalMargin),
            addButton.heightAnchor.constraint(equalToConstant: Constants.addButtonHeight),
            addButton.widthAnchor.constraint(equalToConstant: Constants.addButtonHeight),
        ])
    }
}

extension TodosViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellController = cellController(forRowAt: indexPath)
        cellController.delegate = delegate
        return cellController.view(for: tableView)
    }
}
