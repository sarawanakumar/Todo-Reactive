//
//  Todo.swift
//  TodoReactive
//
//  Created by Saravanakumar Selladurai on 26/11/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import Foundation

struct TodoElement: Codable {
    let id: Int
    let todoDescription, scheduledDate, status: String

    enum CodingKeys: String, CodingKey {
        case id
        case todoDescription = "description"
        case scheduledDate, status
    }
}

typealias Todo = [TodoElement]
