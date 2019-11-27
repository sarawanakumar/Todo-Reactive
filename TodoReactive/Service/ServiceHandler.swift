import Foundation
import ReactiveSwift

typealias Response = (Result<Data, Error>) -> Void

protocol ServiceHandlerProtocol {
    //func handleRequest(url: URL, completion: @escaping Response)
    func handleRequest(url: URL) -> SignalProducer<Data, Error>
}

struct ServiceHandler: ServiceHandlerProtocol {
    static let shared = ServiceHandler()
    //private var session = URLSession.shared

    private init() {}

    func handleRequest(
        url: URL
    ) -> SignalProducer<Data, Error> {
        return SignalProducer<Data, Error> { (observer, lifetime) in
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let data = data {
                    observer.send(value: data)
                } else if let error = error {
                    observer.send(error: error)
                } else {
                    observer.send(error: ApplicationError.networkError)
                }
            }.resume()
        }
    }
}
