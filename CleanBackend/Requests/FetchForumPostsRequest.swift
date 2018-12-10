public struct FetchedForumPostsSuccessEvent: RequestEvent {
    public let forumPosts: [[String: Any]]
}

public struct FetchedForumPostsErrorEvent: RequestEvent {
    public let error: Error
}

// A. 1
final public class FetchForumPostsRequest: HTTPClientDelegate, RequestObserving {
    
    // A. 2
    let eventListenerFactory: RequestEventListenerFactory
    private let client: HTTPClientProviding
    
    // B.
    public convenience init(client: HTTPClient, eventListenerFactory: RequestEventListenerFactory) {
        self.init(clientProvider: client, eventListenerFactory: eventListenerFactory)
    }
    
    init(clientProvider: HTTPClientProviding, eventListenerFactory: RequestEventListenerFactory) {
        self.client = clientProvider
        self.eventListenerFactory = eventListenerFactory
        // C.
        client.delegate = self
    }
    
    // D.
    public func fetchForumPosts(userId: Int?) {
        client.performRequest(with: requestData(userId: userId))
    }
    
    // E.
    private func requestData(userId: Int?) -> RequestData {
        var parameters: [String: String]? = nil
        if let userId = userId {
            parameters = ["userId": "\(userId)"]
        }
        
        return RequestData(
            method: .get,
            path: "posts",
            parameters: parameters
        )
    }
    
    // MARK: - HTTPClientDelegate methods
    // A. 3
    func success(response: Data?) {
        guard
            let responseData = response,
            let responseObject = try? JSONSerialization.jsonObject(with: responseData, options: []),
            let forumPosts = responseObject as? [[String: Any]]
        else {
            return
        }
        
        eventListenerFactory.notifyListeners(FetchedForumPostsSuccessEvent(forumPosts: forumPosts))
    }
    
    func failure(error: Error) {
        eventListenerFactory.notifyListeners(FetchedForumPostsErrorEvent(error: error))
    }
}
