//
//  TodoPresenter.swift
//  TodoEngine
//
//  Created by Will Saults on 2/5/23.
//

import Foundation

public final class TodoPresenter {
    public static func map(_ item: TodoItem) -> TodoItemViewModel {
        TodoItemViewModel(
            text: item.text,
            createdAt: item.createdAt,
            completedAt: item.completedAt
        )
    }
}
