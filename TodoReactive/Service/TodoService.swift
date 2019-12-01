//
//  TodoService.swift
//  TodoReactive
//
//  Created by Saravanakumar Selladurai on 27/11/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import ReactiveSwift

protocol TodoServiceContract {
    func getTodoList() -> SignalProducer<Todo, Error>
}

struct TodoService: TodoServiceContract {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "www.mocky.io"
        components.path = "/v2/582695f5100000560464ca40"

        return components.url
    }

    func getTodoList() -> SignalProducer<Todo, Error> {
        guard let url = url else { return .empty }

        return ServiceHandler.shared
            .handleRequest(url: url)
            .map { (data) in
                try! JSONDecoder().decode(Todo.self, from: data)
            }
    }
}
