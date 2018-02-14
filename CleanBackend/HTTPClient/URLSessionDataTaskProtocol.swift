import Foundation

protocol URLSessionDataTaskProtocol {
    var currentRequest: URLRequest? { get }
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
