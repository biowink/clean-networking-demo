import XCTest
@testable import CleanBackend

final class PostsRequestTests: XCTestCase {
    private let mockListenerFactory = MockRequestEventListenerFactory()
    private var sut: ForumPostsRequest!
    private var mockClient: MockHTTPClientProvider!
    
    override func setUp() {
        mockClient = MockHTTPClientProvider()
        sut = ForumPostsRequest(
            clientProvider: mockClient,
            eventListenerFactory: mockListenerFactory
        )
    }
    
    func testRequestParameters() {
        sut.fetchPosts(userId: 123)
        let requestData = mockClient.spyPerformedRequestData
        XCTAssertNotNil(requestData)
        XCTAssertEqual("123", requestData?.parameters?["userId"])
    }
    
    func test_successfulRequest_sendsEventWithParsedResponse() {
        let data = TestUtils.data(fromFile: "response", withExtension: "json")
        sut.success(response: data)

        let event = mockListenerFactory.listener.lastEvent as? FetchedPostsEvent
        XCTAssertEqual(10, event?.posts.count)
    }

    func test_nilData_doesNotSendEvent() {
        sut.success(response: nil)
        XCTAssertNil(mockListenerFactory.listener.lastEvent)
    }

    func test_malformedJSON_doesNotSendEvent() {
        let data = TestUtils.data(fromFile: "malformed_response", withExtension: "json")

        sut.success(response: data)
        XCTAssertNil(mockListenerFactory.listener.lastEvent)
    }
}

final class MockRequestEventListenerFactory: RequestEventListenerFactory {
    let listener = MockRequestListener()
    
    var eventListeners: [RequestEventListening] {
        return [listener]
    }
}

final class MockRequestListener: RequestEventListening {
    var lastEvent: RequestEvent?
    
    func notify(_ event: RequestEvent) {
        lastEvent = event
    }
}
