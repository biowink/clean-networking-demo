import XCTest
@testable import CleanBackend

class HTTPClientTests: XCTestCase {
    private let mockSessionProvider = MockSessionProvider()
    private let requestData = RequestData(method: .get, path: "test", body: nil)
    private var mockDelegate: MockHTTPClientDelegate!
    private var mockConfiguration: RequestConfiguration!
    private var sut: HTTPClient!

    override func setUp() {
        mockConfiguration = RequestConfiguration(baseUrl: URL(string: "http://xxx.yyy.com")!)
        sut = HTTPClient(configuration: mockConfiguration, sessionProvider: mockSessionProvider)
        mockDelegate = MockHTTPClientDelegate()
        sut.delegate = mockDelegate
    }

    func test_resumeIsCalled() {
        sut.performRequest(with: requestData)
        XCTAssertTrue(mockSessionProvider.mockSession.mockDataTask.resumeWasCalled)
    }

    func test_error_triggersFailureHandler() {
        mockSessionProvider.mockSession.nextError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil) as Error
        sut.performRequest(with: requestData)
        XCTAssertTrue(mockDelegate.failureWasCalled)
    }

    func test_noHTTPResponse_triggersFailureHandler() throws {
        mockSessionProvider.mockSession.nextResponse = nil
        sut.performRequest(with: requestData)
        XCTAssertTrue(mockDelegate.failureWasCalled)
        XCTAssertEqual(HTTPClientError.noHTTPResponse, mockDelegate.lastError as? HTTPClientError)
    }

    func test_genericResponse_triggersFailureHandler() throws {
        mockSessionProvider.mockSession.nextResponse = URLResponse(
            url: URL(string: "http://xxx.yyy.com")!, mimeType: "text/plain", expectedContentLength: 123, textEncodingName: nil
        )
        sut.performRequest(with: requestData)
        XCTAssertTrue(mockDelegate.failureWasCalled)

        XCTAssertEqual(HTTPClientError.noHTTPResponse, mockDelegate.lastError as? HTTPClientError)
    }

    func test_statusCode400_triggersFailureHandler() throws {
        mockSessionProvider.mockSession.nextResponse = HTTPURLResponse(
            url: URL(string: "http://xxx.yyy.com")!, statusCode: 400, httpVersion: nil, headerFields: nil
        )
        sut.performRequest(with: requestData)
        XCTAssertTrue(mockDelegate.failureWasCalled)
        XCTAssertEqual(HTTPClientError.badRequest, mockDelegate.lastError as? HTTPClientError)
    }

    func test_statusCode500_triggersFailureHandler() throws {
        mockSessionProvider.mockSession.nextResponse = HTTPURLResponse(
            url: URL(string: "http://xxx.yyy.com")!, statusCode: 500, httpVersion: nil, headerFields: nil
        )
        sut.performRequest(with: requestData)
        XCTAssertTrue(mockDelegate.failureWasCalled)
        XCTAssertEqual(HTTPClientError.serverError, mockDelegate.lastError as? HTTPClientError)
    }

    func test_statusCode200_triggersSuccessHandler() throws {
        mockSessionProvider.mockSession.nextResponse = HTTPURLResponse(
            url: URL(string: "http://xxx.yyy.com")!, statusCode: 200, httpVersion: nil, headerFields: nil
        )
        sut.performRequest(with: requestData)
        XCTAssertTrue(mockDelegate.successWasCalled)
        XCTAssertNil(mockDelegate.lastError)
    }
}

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false

    var spyCurrentRequest: URLRequest?
    var currentRequest: URLRequest? {
        set { spyCurrentRequest = newValue }
        get { return nil }
    }

    func resume() {
        resumeWasCalled = true
    }
}

final class MockURLSession: URLSessionProtocol {
    var mockDataTask = MockURLSessionDataTask()
    private (set) var lastURLRequest: URLRequest?
    var nextData: Data?
    var nextError: Error?
    var nextResponse: URLResponse?

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURLRequest = request
        completionHandler(nextData, nextResponse, nextError)
        return mockDataTask
    }
}

final class MockSessionProvider: URLSessionProviding {
    private (set) var mockSession = MockURLSession()

    func session() -> URLSessionProtocol {
        return mockSession
    }
}

final class MockHTTPClientDelegate: HTTPClientDelegate {
    private (set) var successWasCalled = false
    private (set) var failureWasCalled = false
    private (set) var lastError: Error?

    func success(response: Data?) {
        successWasCalled = true
    }
    
    func failure(error: Error) {
        failureWasCalled = true
        lastError = error
    }
}
