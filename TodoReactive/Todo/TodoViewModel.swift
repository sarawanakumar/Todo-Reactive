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

    convenience init(service: TodoService = TodoService()) {
        self.init(
            initial: State(items: [:]),
            scheduler: UIScheduler(),
            service: service
        )
    }

    init(initial: State, scheduler: Scheduler, service: TodoService) {
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

    static func whenLoading(_ todoService: TodoService) -> Feedback<State, Event> {
        return Feedback(predicate: { (state: State) in
            state.pageStatus == .loading
        }) { _ -> SignalProducer<Event, Never> in
            return todoService.getTodoList()
                .map { .didLoad($0) }
                .flatMapError { _ in .never }
        }
    }

    func send(action: Action) {
        input.observer(.ui(action))
    }

    static func reduce(state: State, event: Event) -> State {
        switch event {
        case .didLoad(let todos):
            return state.with {
                $0.items = TodoElement.arrangedTasks(todos: todos)
                $0.pageStatus = .displayed
            }
        case .ui(.toggleTask(let taskId)):
            return state.with { s in
//                guard let task = $0.items
//                    .filter({$0.id == taskId})
//                    .first else { return }
//
//                var newTask = task
//                newTask.isTodoCompleted = !task.isTodoCompleted
//
//                $0.items.removeAll(where: {$0.id == taskId})
//                $0.items.append(newTask)
//                $0.items.sort { $0.id < $1.id }
            }
        }
    }

    struct State: Then {
        var items: [TodoElement.TodoStatus: Todo]
        var pageStatus: Status = .loading

        enum Status {
            case loading
            case displayed
            case failed
        }
    }

    enum Event {
        case didLoad(Todo)
        case ui(Action)
    }

    enum Action {
        case toggleTask(id: Int)
    }
}
