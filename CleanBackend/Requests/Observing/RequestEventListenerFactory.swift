public protocol RequestEventListenerFactory {
    var eventListeners: [RequestEventListening] { get }
    func notifyListeners(_ event: RequestEvent)
}

public extension RequestEventListenerFactory {
    func notifyListeners(_ event: RequestEvent) {
        eventListeners.forEach { $0.notify(event) }
    }
}
