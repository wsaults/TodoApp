//
//  TodosViewController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import UIKit

public protocol TodosViewControllerCachingDelegate: AnyObject {
    func didAdd()
}

public final class TodosViewController: UIViewController {
    public typealias TodosCacheController = (TodosViewControllerCachingDelegate & TodoCellControllerDelegate)
    
    private enum Constants {
        static let horizontalMargin = 40.0
        static let addButtonHeight = 60.0
        static let addButtonImageName = "plus"
    }
    
    private var refreshController: TodosRefreshViewController?
    weak var delegate: TodosCacheController?
    
    private var noTodosLabel: UILabel = {
        var label = UILabel()
        label.text = "Get started by tapping\n the ➕ button below 😎"
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TodoCell.self)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshController?.view
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        return tableView
    }()
    
    public var tableModel = [TodoCellController]() {
        didSet { reloadData() }
    }
    
    public lazy var addButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .systemGray4
        configuration.baseBackgroundColor = .systemBlue
        configuration.cornerStyle = .capsule
        
        configuration.image = UIImage(
            systemName: Constants.addButtonImageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.addButtonHeight / 2, weight: .bold, scale: .large))
        let action = UIAction(handler: { [weak self] _ in self?.addButtonTapped() })
        let button = UIButton(configuration: configuration, primaryAction: action)
        button.keyboardLayoutGuide.followsUndockedKeyboard = true
        return button
    }()
    
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
        
        view.backgroundColor = .systemBackground
        
        addViews()
        setConstraints()
        
        refreshController?.refresh()
    }
    
    private func reloadData() {
        noTodosLabel.isHidden = !tableModel.isEmpty
        tableView.reloadData()
    }
    
    private func addViews() {
        view.addSubview(tableView)
        view.addSubview(noTodosLabel)
        view.addSubview(addButton)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> TodoCellController {
        tableModel[indexPath.row]
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        noTodosLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noTodosLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noTodosLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noTodosLabel.topAnchor.constraint(equalTo: view.topAnchor),
            noTodosLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            tableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalMargin),
            addButton.heightAnchor.constraint(equalToConstant: Constants.addButtonHeight),
            addButton.widthAnchor.constraint(equalToConstant: Constants.addButtonHeight),
        ])
        
        let addButtonOnKeyboard = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 30)
        view.keyboardLayoutGuide.setConstraints([addButtonOnKeyboard], activeWhenAwayFrom: .top)
    }
    
    private func addButtonTapped() {
        delegate?.didAdd()
    }
    
    private func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

extension TodosViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellController = cellController(forRowAt: indexPath)
        cellController.delegate = delegate
        cellController.cellContentListener = { [weak self] in
            self?.updateTableView()
        }
        return cellController.view(for: tableView)
    }
}
