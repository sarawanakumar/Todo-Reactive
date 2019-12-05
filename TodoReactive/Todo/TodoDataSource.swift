//
//  TodoDataSource.swift
//  TodoReactive
//
//  Created by Saravanakumar Selladurai on 05/12/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import UIKit

class TodoDataSource<Section: Hashable, Item
    : Hashable>: UITableViewDiffableDataSource<Section, Item> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return TodoStatus.pending.rawValue
        case 1:
            return TodoStatus.completed.rawValue
        default:
            return ""
        }
    }
}
