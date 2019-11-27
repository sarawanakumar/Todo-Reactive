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

    convenience init(name: String) {
        self.init(State(items: []), UIScheduler())
    }

    init(_ initial: State, _ scheduler: Scheduler) {
        state = Property(
            initial: initial,
            scheduler: scheduler,
            reduce: TodoViewModel.reduce,
            feedbacks: [
                input.feedback,
                TodoViewModel.whenLoading(TodoService())
            ]
        )
    }

    static func whenLoading(_ todoService: TodoService) -> Feedback<State, Event> {
        return Feedback(predicate: { (state: State) in
            state.isPageLoading
        }) { _ -> SignalProducer<Event, Never> in
            return todoService.getTodoList()
                .map { .didLoad($0) }
                .flatMapError { _ in .never }
        }
    }

    func send(action: Action) {
        input.observer(.ui(.buttonTapped))
    }

    static func reduce(state: State, event: Event) -> State {
        switch event {
        case .select:
            return state
        case .didLoad(let todo):
            return state.with {
                $0.items = todo
                $0.isPageLoading = false
            }
        case .ui(.buttonTapped):
            return state.with {
                $0.shouldHideLabel = !$0.shouldHideLabel
            }
        }
    }

    struct State: Then {
        var shouldHideLabel = true
        var items: Todo
        var isPageLoading = true

        enum Status {
            case loading
            case displayed
            case failed
        }
    }

    enum Event {
        case select
        case didLoad(Todo)
        case ui(Action)
    }

    enum Action {
        case buttonTapped
    }
}
