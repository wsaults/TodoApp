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
    
    private func silentRefresh() {
        viewModel.load(shouldNotify: false)
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingStateChange = { [weak view] isLoading in
            isLoading ? view?.beginRefreshing() : view?.endRefreshing()
        }
        viewModel.onSavingStateChange = { [weak self] isSaving in
            if !isSaving { self?.silentRefresh() }
        }
        viewModel.onDeletionStateChange = { [weak self] isDeleting in
            if !isDeleting { self?.silentRefresh() }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
