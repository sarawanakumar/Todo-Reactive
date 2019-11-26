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
    var cellViewModel: Property<[TodoCellViewModel]>!

    override func refresh(_ state: TodoViewModel.State) {
        let data = state.items.map { todoItem in
            TodoCellViewModel(
                name: todoItem.name,
                isCompleted: todoItem.isComplete,
                taskToggled: send!
            )
        }
        cellViewModel = Property(value: data)
    }
}

extension TodoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModel.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as? TodoTableViewCell else { return UITableViewCell() }

        cell.cellViewModel = Property(value: cellViewModel.value[indexPath.row])
        return cell
    }
}

