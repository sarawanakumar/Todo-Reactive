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
    var cellViewModels = [TodoCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            UINib(nibName: "TodoTableViewCell", bundle: nil),
            forCellReuseIdentifier: "todoCell"
        )
    }

    override func refresh(_ state: TodoViewModel.State) {
        switch state.pageStatus {
        case .displayed:
            cellViewModels = state.items.map { todoItem in
                TodoCellViewModel(
                    name: todoItem.todoDescription,
                    isCompleted: todoItem.isTodoCompleted,
                    taskToggled: { [weak self] in
                        self?.send?(.toggleTask(id: todoItem.id))
                    }
                )
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? TodoTableViewCell else { return UITableViewCell() }

        cell.viewModel = Property(value: cellViewModels[indexPath.row])
        return cell
    }
}

