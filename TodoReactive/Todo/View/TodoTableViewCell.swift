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
    @IBOutlet weak var isCompletedSwitch: UISwitch!
    private var send: ((TodoViewController.Action) -> Void)?

    var cellViewModel: Property<TodoCellViewModel>!

    override func awakeFromNib() {
        super.awakeFromNib()

        cellViewModel.producer.startWithValues { [unowned self] model in
            self.itemDescriptionLabel.text = model.name
            self.isCompletedSwitch.setOn(model.isCompleted, animated: true)
            self.send = model.taskToggled
        }
    }

    @IBAction func toggleTask(sender: UISwitch) {
        send?(.buttonTapped)
    }
}

struct TodoCellViewModel {
    var name: String
    var isCompleted: Bool
    var taskToggled: (TodoViewModel.Action) -> Void
}
