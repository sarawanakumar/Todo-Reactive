//
//  TodoTableViewCell.swift
//  TodoReactive
//
//  Created by Saravanakumar Selladurai on 26/11/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import UIKit
import ReactiveSwift

class TodoTableViewCell: UITableViewCell {
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemDateLabel: UILabel!
    @IBOutlet weak var isCompletedSwitch: UISwitch!
    private var switchDidToggle: (() -> Void)?

    var viewModel: TodoCellViewModel! {
        didSet {
            self.itemDescriptionLabel.text = viewModel.name
            self.isCompletedSwitch.setOn(viewModel.isCompleted, animated: true)
            self.itemDateLabel.text = viewModel.dueDate
            self.switchDidToggle = viewModel.taskToggled
        }
    }

    @IBAction func toggleTask(sender: UISwitch) {
        switchDidToggle?()
    }
}

struct TodoCellViewModel: Hashable {
    var id: Int
    var name: String
    var isCompleted: Bool
    var dueDate: String
    var taskToggled: () -> Void

    init(todo: TodoElement, onToggle: @escaping () -> Void) {
        self.id = todo.id
        self.name = todo.todoDescription
        self.isCompleted = todo.todoStatus == .completed
        self.dueDate = todo.formattedDate
        self.taskToggled = onToggle
    }

    static func == (lhs: TodoCellViewModel, rhs: TodoCellViewModel) -> Bool {
        return (lhs.name == rhs.name) && (lhs.isCompleted == rhs.isCompleted) && (lhs.dueDate == rhs.dueDate)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
