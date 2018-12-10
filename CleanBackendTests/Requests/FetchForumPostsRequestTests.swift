import XCTest
@testable import CleanBackend

final class MockRequestListener: RequestEventListening {
    var lastEvent: RequestEvent?
    
    func notify(_ event: RequestEvent) {
        lastEvent = event
    }
}

final class MockRequestEventListenerFactory: RequestEventListenerFactory {
    let listener = MockRequestListener()
    
    var eventListeners: [RequestEventListening] {
        return [listener]
    }
}

final class FetchForumPostsRequestTests: XCTestCase {
    private let mockListenerFactory = MockRequestEventListenerFactory()
    private var sut: FetchForumPostsRequest!
    private var mockClient: MockHTTPClientProvider!
    
    override func setUp() {
        mockClient = MockHTTPClientProvider()
        sut = FetchForumPostsRequest(
            clientProvider: mockClient,
            eventListenerFactory: mockListenerFactory
        )
    }
    
    // A.
    func testDelegateIsSet() {
        XCTAssertNotNil(mockClient.delegate)
    }
    
    // B.
    func testRequestDataIsSet() {
        sut.fetchForumPosts(userId: 123)
        let requestData = mockClient.spyPerformedRequestData
        XCTAssertNotNil(requestData)
    }
    
    // C.
    func testRequestParameters() {
        sut.fetchForumPosts(userId: 123)
        let requestData = mockClient.spyPerformedRequestData
        XCTAssertEqual("123", requestData?.parameters?["userId"])
    }
    
    // D.
    func test_successfulRequest_sendsEventWithParsedResponse() {
        let data = TestUtils.data(fromFile: "10_mocked_posts_response", withExtension: "json")
        sut.success(response: data)
        let event = mockListenerFactory.listener.lastEvent as? FetchedForumPostsSuccessEvent
        XCTAssertEqual(10, event?.forumPosts.count)
    }

    // E.
    func test_nilData_doesNotSendEvent() {
        sut.success(response: nil)
        XCTAssertNil(mockListenerFactory.listener.lastEvent)
    }

    // F.
    func test_malformedJSON_doesNotSendEvent() {
        let data = TestUtils.data(fromFile: "malformed_response", withExtension: "json")
        sut.success(response: data)
        XCTAssertNil(mockListenerFactory.listener.lastEvent)
    }
    
    // G.
    func test_failedRequest_sendsErrorEvent() {
        let mockError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Mock error message"]) 
        sut.failure(error: mockError)
        let errorEvent = mockListenerFactory.listener.lastEvent as? FetchedForumPostsErrorEvent
        XCTAssertEqual("Mock error message", errorEvent?.error.localizedDescription)
    }
}
