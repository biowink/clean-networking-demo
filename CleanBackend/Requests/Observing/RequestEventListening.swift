public protocol RequestEventListening {
    func notify(_ event: RequestEvent)
}
