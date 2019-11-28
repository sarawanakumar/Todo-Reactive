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
    var cellViewModels = [TodoElement.TodoStatus: [TodoCellViewModel]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            UINib(
                nibName: "TodoTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "todoCell"
        )
    }

    override func refresh(_ state: TodoViewModel.State) {
        switch state.pageStatus {
        case .displayed:
            let allStatus: [TodoElement.TodoStatus] = [.completed, .pending]
            for status in allStatus {
                cellViewModels[status] = state.items[status]?
                    .map { todoItem in
                        TodoCellViewModel(
                            name: todoItem.todoDescription,
                            isCompleted: todoItem.todoStatus == .completed,
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
            tableView.reloadData()
        case .failed:
            ()
        case .loading:
            ()
        }
    }
}

extension TodoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cellViewModels[.pending]?.count ?? 0
        case 1:
            return cellViewModels[.completed]?.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? TodoTableViewCell else { return UITableViewCell() }

        switch indexPath.section {
        case 0:
            cell.viewModel = cellViewModels[.pending]?[indexPath.row]
        case 1:
            cell.viewModel = cellViewModels[.completed]?[indexPath.row]
        default:
            cell.viewModel = nil
        }
        return cell
    }
}

extension TodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Pending"
        case 1:
            return "Completed"
        default:
            return ""
        }
    }
}
