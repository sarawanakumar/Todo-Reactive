import ReactiveFeedback
import ReactiveSwift

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
