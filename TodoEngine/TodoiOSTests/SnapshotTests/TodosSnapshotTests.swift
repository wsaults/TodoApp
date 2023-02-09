//
//  TodosSnapshotTests.swift
//  TodoiOSTests
//
//  Created by Will Saults on 2/9/23.
//

@testable import TodoEngine
@testable import TodoiOS
import XCTest

class TodosSnapshotTests: XCTestCase {
    
    func test_emptyTodos() {
        let sut = makeSUT()
        
        sut.display(emptyTodos())
        
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "EMPTY_TODOS_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "EMPTY_TODOS_dark")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light, contentSize: .extraExtraExtraLarge)), named: "EMPTY_TODOS_light_extraExtraExtraLarge")
    }
    
    func test_todosWithEmptyContent() {
        let sut = makeSUT()
        
        sut.display(todosWithEmptyContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "TODOS_WITH_EMPTY_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "TODOS_WITH_EMPTY_CONTENT_dark")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light, contentSize: .extraExtraExtraLarge)), named: "TODOS_WITH_EMPTY_CONTENT_extraExtraExtraLarge")
    }
    
    func test_todosWithContent() {
        let sut = makeSUT()
        
        sut.display(todosWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "TODOS_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "TODOS_WITH_CONTENT_dark")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light, contentSize: .extraExtraExtraLarge)), named: "TODOS_WITH_CONTENT_extraExtraExtraLarge")
    }
    
    func test_todosWithMultiLineContent() {
        let sut = makeSUT()
        
        sut.display(todosWithMultiLineContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "TODOS_WITH_MULTILINE_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "TODOS_WITH_MULTILINE_CONTENT_dark")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light, contentSize: .extraExtraExtraLarge)), named: "TODOS_WITH_MULTILINE_CONTENT_extraExtraExtraLarge")
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> TodosViewController {
        let sut = TodosViewController()
        sut.noTodosLabel.text = "Get started by tapping\n the ➕ button below 😎"
        sut.tableView.showsVerticalScrollIndicator = false
        sut.tableView.showsHorizontalScrollIndicator = false
        return sut
    }
    
    private func emptyTodos() -> [TodoStub] {
        []
    }
    
    private func todosWithContent() -> [TodoStub] {
        [
            TodoStub(text: "Complete sample iOS Todo App", createdAt: Date.now.addHours(-3), completedAt: Date.now),
            TodoStub(text: "Write article about SOLID principals", createdAt: Date.now.addHours(-2)),
            TodoStub(text: "Work on side project", createdAt: Date.now.addHours(-1))
        ]
    }
    
    private func todosWithEmptyContent() -> [TodoStub] {
        [
            TodoStub(text: "", createdAt: Date.now.addHours(-3), completedAt: Date.now),
            TodoStub(text: "", createdAt: Date.now.addHours(-2))
        ]
    }
    
    private func todosWithMultiLineContent() -> [TodoStub] {
        [
            TodoStub(text: "Learn something new every day and work hard towards continuing to expand on my growing list of skill sets.", createdAt: Date.now)
        ]
    }
}

private extension TodosViewController {
    func display(_ stubs: [TodoStub]) {
        tableModel = stubs.map { stub in
            let cellController = TodoCellController(viewModel: stub.viewModel)
            stub.controller = cellController
            return cellController
        }
    }
}

private class TodoStub: TodoCellControllerDelegate {
    let viewModel: TodoItemViewModel
    weak var controller: TodoCellController?
    
    init(text: String, createdAt: Date, completedAt: Date? = nil) {
        self.viewModel = TodoItemViewModel(uuid: UUID(), text: text, createdAt: createdAt, completedAt: completedAt)
    }
    
    func didChange(viewModel: TodoEngine.TodoItemViewModel, shouldNotify: Bool) {}
    func didDelete(viewModel: TodoEngine.TodoItemViewModel) {}
}
