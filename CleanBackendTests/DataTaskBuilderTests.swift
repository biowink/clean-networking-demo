import XCTest
@testable import CleanBackend

class DataTaskBuilderTests: XCTestCase {
    private let urlSession = URLSession.shared
    private var sut: DataTaskBuilder!

    override func setUp() {
        sut = DataTaskBuilder(urlSession: urlSession,
                              baseUrl: URL(string: "http://xxx.yyy.com")!)
    }

    func test_taskHasCorrectURLAndHTTPMethod() {
        let request = RequestData.create()
        let task = sut.task(from: request) { (_, _, _) in }

        XCTAssertEqual(task?.currentRequest?.url?.absoluteString, "http://xxx.yyy.com/test")
        XCTAssertEqual(task?.currentRequest?.httpMethod, "GET")
        XCTAssertNil(task?.currentRequest?.httpBody)
    }

    func test_taskPOSTTask_appendsBody() {
        let request = RequestData(
            method: .post,
            path: "test",
            body: ["key":"value"]
        )

        let task = sut.task(from: request) { (_, _, _) in }
        XCTAssertNotNil(task?.currentRequest?.httpBody)
    }

    func test_contentType_isJSON() {
        let request = RequestData.create()
        let task = sut.task(from: request) { (_, _, _) in }

        let contentTypeField = task?.currentRequest?.allHTTPHeaderFields?["Content-Type"]
        XCTAssertEqual("application/json", contentTypeField)
    }
}

extension RequestData {
    static func create(authenticated: Bool = false) -> RequestData {
        return RequestData(
            method: .get,
            path: "test",
            body: nil
        )
    }
}
