//
//  TodosRefreshViewController.swift
//  TodoiOS
//
//  Created by Will Saults on 2/6/23.
//

import TodoEngine
import UIKit

public final class TodosRefreshViewController: NSObject {
    private(set) lazy var view = binded(UIRefreshControl())
    
    private let viewModel: TodosViewModel
    
    public init(viewModel: TodosViewModel) {
        self.viewModel = viewModel
    }
    
    @objc public func refresh() {
        viewModel.load()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            isLoading ? view?.beginRefreshing() : view?.endRefreshing()
        }
        viewModel.onSavingStateChange = { [weak self] isSaving in
            if !isSaving { self?.refresh() }
        }
        viewModel.onDeletionStateChange = { [weak self] isDeleting in
            if !isDeleting { self?.refresh() }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
