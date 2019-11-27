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
        cellViewModels = state.items.map {
            TodoCellViewModel(
                name: $0.todoDescription,
                isCompleted: true,
                taskToggled: { [weak self] in
                    self?.send?(.buttonTapped)
                }
            )
        }
        tableView.reloadData()
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

