import ReactiveSwift

protocol BaseViewModel: AnyObject {
    associatedtype State
    associatedtype Action

    var state: Property<State> { get }
    func send(action: Action)
}
