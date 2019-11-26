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
                input.feedback
            ]
        )
    }

    func send(action: TodoViewModel.Action) {
        input.observer(.ui(.buttonTapped))
    }

    static func reduce(state: State, event: Event) -> State {
        switch event {
        case .select:
            return state
        case .ui(.buttonTapped):
            return state.with {
                $0.shouldHideLabel = !$0.shouldHideLabel
            }
        }
    }

    struct State: Then {
        var shouldHideLabel = true
        var items: [Todo]
    }

    enum Event {
        case select
        case ui(Action)
    }

    enum Action {
        case buttonTapped
    }
}

protocol BaseViewModel: AnyObject {
    associatedtype State
    associatedtype Action

    var state: Property<State> { get }
    func send(action: Action)
}


extension Feedback {
    public static func input() -> (feedback: Feedback<State, Event>, observer: (Event) -> Void) {
        let pipe = Signal<Event, Never>.pipe()
        let feedback = Feedback { (scheduler: Scheduler, _) -> Signal<Event, Never> in
            return pipe.output
                .promoteError(Never.self)
                .observe(on: scheduler)
        }
        return (feedback, pipe.input.send)
    }
}
