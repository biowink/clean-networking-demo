protocol HTTPClientProviding: class {
    var delegate: HTTPClientDelegate? { get set }
    func performRequest(with data: RequestData)
}
