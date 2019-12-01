//
//  TodoViewModel.swift
//  TodoReactive
//
//  Created by Saravanakumar Selladurai on 26/11/19.
//  Copyright © 2019 Saravanakumar Selladurai. All rights reserved.
//

import ReactiveFeedback
import ReactiveSwift

class TodoViewModel: BaseViewModel {
    let input = Feedback<State, Event>.input()
    let state: Property<State>

    convenience init(service: TodoServiceContract, scheduler: Scheduler) {
        self.init(
            initial: State(),
            scheduler: scheduler,
            service: service
        )
    }

    init(initial: State, scheduler: Scheduler, service: TodoServiceContract) {
        state = Property(
            initial: initial,
            scheduler: scheduler,
            reduce: TodoViewModel.reduce,
            feedbacks: [
                input.feedback,
                TodoViewModel.whenLoading(service)
            ]
        )
    }

    static func whenLoading(_ todoService: TodoServiceContract) -> Feedback<State, Event> {
        func todoDictionary(todos: Todo) -> [TodoStatus: Todo] {
            return Dictionary(
                uniqueKeysWithValues: TodoStatus.allCases
                    .flatMap { status -> [TodoStatus: Todo] in
                        [status: todos.filter {$0.todoStatus == status}]
                    }
                )
        }

        return Feedback(
            predicate: { state in
                state.pageStatus == .loading
                }
            ) { _ -> SignalProducer<Event, Never> in
                todoService.getTodoList()
                    .map { .didLoad(todoDictionary(todos: $0)) }
                    .flatMapError { error in
                        .init(
                            value: .didFail(message: error.localizedDescription
                            )
                        )
                    }
                }
    }

    func send(action: Action) {
        input.observer(.ui(action))
    }

    static func reduce(state: State, event: Event) -> State {
        switch event {
        case .didLoad(let todos):
            return state.with {
                $0.items = todos
                $0.pageStatus = .displayed
            }
        case .didFail(let message):
            return state.with {
                $0.pageStatus = .failed(message)
            }
        case .ui(.toggleTask(let taskId, let taskStatus)):
            return state.with {
                guard let task = $0.items[taskStatus]?
                    .first(where: { $0.id == taskId }) else { return }

                $0.items[taskStatus]?.removeAll { $0.id == taskId }

                var newTask = task
                newTask.todoStatus.toggle()
                $0.items[newTask.todoStatus]?.append(newTask)
            }
        }
    }

    struct State: Then {
        var items = [TodoElement.TodoStatus: Todo]()
        var pageStatus: Status = .loading

        enum Status: Equatable {
            case loading
            case displayed
            case failed(String)
        }
    }

    enum Event {
        case didLoad([TodoStatus: Todo])
        case didFail(message: String)
        case ui(Action)
    }

    enum Action {
        case toggleTask(id: Int, currentStatus: TodoElement.TodoStatus)
    }
}
