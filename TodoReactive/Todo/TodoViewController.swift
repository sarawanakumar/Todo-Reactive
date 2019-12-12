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
        let cellViewModels = data.mapValues {
            $0.map { todo in
                TodoCellViewModel(todo: todo) { [unowned self] in
                    self.send(
                        .toggleTask(
                            id: todo.id,
                            currentStatus: todo.todoStatus
                        )
                    )
                }
            }
        }
        updateTableView(with: cellViewModels)
    }
}

extension TodoViewController {
    func makeDataSource() -> TodoDataSource<TodoStatus, TodoCellViewModel> {
        return TodoDataSource(tableView: tableView) { (tableView, indexPath, cellViewModel) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TodoTableViewCell

            cell?.viewModel = cellViewModel
            return cell
        }
    }

    func updateTableView(with models: [TodoStatus: [TodoCellViewModel]]) {
        var snapshot = NSDiffableDataSourceSnapshot<TodoStatus, TodoCellViewModel>()

        snapshot.appendSections(TodoStatus.allCases)
        models.forEach { (key, value) in
            snapshot.appendItems(value, toSection: key)
        }
        dataSource.apply(snapshot)
    }
}
