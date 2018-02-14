import Foundation

protocol URLSessionProviding {
    func session() -> URLSessionProtocol
}

class DefaultURLSessionProvider: URLSessionProviding {
    func session() -> URLSessionProtocol {
        return URLSession(configuration: .default,
                          delegate: nil,
                          delegateQueue: nil)
    }
}
