//
//  TodosPresenter.swift
//  TodoEngine
//
//  Created by Will Saults on 2/5/23.
//

import Foundation

public final class TodosPresenter {
    public static var title: String {
        NSLocalizedString("TODOS_VIEW_TITLE",
              tableName: "Todos",
              bundle: Bundle(for: TodosPresenter.self),
              comment: "Title for the tasks view")
    }
}
