//
//  TodoViewController.swift
//  TodoReactive
//
//  Created by Saravanakumar Selladurai on 26/11/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import UIKit
import ReactiveSwift

class TodoViewController: BaseViewController<TodoViewModel> {
    @IBOutlet weak var tableView: UITableView!
    var dataSource: TodoDataSource<TodoStatus, TodoCellViewModel>!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            UINib(
                nibName: "TodoTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "todoCell"
        )
        self.dataSource = makeDataSource()
    }

    override func refresh(_ state: TodoViewModel.State) {
        switch state.pageStatus {
        case .displayed:
            renderView(for: state.items)
        case .failed:
            ()
        case .loading:
            ()
        }
    }

    private func renderView(for data: [TodoStatus: Todo]) {
        var cellViewModels = [TodoElement.TodoStatus: [TodoCellViewModel]]()
        [.completed, .pending].forEach { status in
            cellViewModels[status] = data[status]?
                .map { todoItem in
                    TodoCellViewModel(
                        id: todoItem.id,
                        name: todoItem.todoDescription,
                        isCompleted: todoItem.todoStatus == .completed,
                        dueDate: todoItem.formattedDate,
                        taskToggled: { [weak self] in
                            self?.send?(
                                .toggleTask(
                                    id: todoItem.id,
                                    currentStatus: todoItem.todoStatus
                                )
                            )
                        }
                    )
            }
        }
        updateTableView(with: cellViewModels)
    }
}

extension TodoViewController {
    func makeDataSource() -> TodoDataSource<TodoStatus, TodoCellViewModel> {
        return TodoDataSource(tableView: tableView) { (tableView, ip, cellViewModel) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: ip) as? TodoTableViewCell

            cell?.viewModel = cellViewModel
            return cell
        }
    }

    func updateTableView(with models: [TodoElement.TodoStatus: [TodoCellViewModel]]) {
        var snapshot = NSDiffableDataSourceSnapshot<TodoStatus, TodoCellViewModel>()

        snapshot.appendSections([.completed, .pending])
        models.forEach { (key, value) in
            snapshot.appendItems(value, toSection: key)
        }
        dataSource.apply(snapshot)
    }
}
