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
            uuid: item.uuid,
            text: item.text,
            createdAt: item.createdAt,
            completedAt: item.completedAt
        )
    }
    
    public static func map(_ itemViewModel: TodoItemViewModel) -> TodoItem {
        TodoItem(
            uuid: itemViewModel.uuid,
            text: itemViewModel.text,
            createdAt: itemViewModel.createdAt,
            completedAt: itemViewModel.completedAt
        )
    }
}
