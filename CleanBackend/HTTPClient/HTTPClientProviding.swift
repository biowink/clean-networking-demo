protocol HTTPClientProviding: class {
    // A.
    var delegate: HTTPClientDelegate? { get set }
    // B.
    func performRequest(with data: RequestData)
}
