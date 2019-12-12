import ReactiveFeedback
import ReactiveSwift

protocol View {
    associatedtype State
    associatedtype Action

    var send: ((Action) -> Void)! { get set }
    func refresh(_ state: State)
}

class BaseViewController<ViewModel: BaseViewModel>: UIViewController, View {
    typealias State = ViewModel.State
    typealias Action = ViewModel.Action
    typealias Sink<Action> = (Action) -> Void

    var viewModel: ViewModel?
    var send: ((Action) -> Void)!

    func refresh(_ state: ViewModel.State) {}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let state = viewModel?.state else { return }

        send = { [weak viewModel] in viewModel?.send(action: $0) }

        SignalProducer(state)
            .observe(on: UIScheduler())
            .startWithValues { [weak self](state) in
                guard let self = self else { return }
                self.refresh(state)
        }
    }
}
