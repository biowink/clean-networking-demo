@testable import CleanBackend

final class MockHTTPClientProvider: HTTPClientProviding {
    var delegate: HTTPClientDelegate?

    var didPerformRequest = false
    var spyPerformedRequestData: RequestData?
    func performRequest(with data: RequestData) {
        didPerformRequest = true
        spyPerformedRequestData = data
    }
}
