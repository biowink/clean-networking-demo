public struct FetchedPostsEvent: RequestEvent {
    public let posts: [[String: Any]]
}

public struct FetchedPostsErrorEvent: RequestEvent {
    public let error: Error
}

final public class ForumPostsRequest: HTTPClientDelegate {
    private let client: HTTPClientProviding
    private let eventListenerFactory: RequestEventListenerFactory
    
    public convenience init(client: HTTPClient, eventListenerFactory: RequestEventListenerFactory) {
        self.init(clientProvider: client, eventListenerFactory: eventListenerFactory)
    }
    
    init(clientProvider: HTTPClientProviding, eventListenerFactory: RequestEventListenerFactory) {
        self.client = clientProvider
        self.eventListenerFactory = eventListenerFactory
        client.delegate = self
    }
    
    public func fetchPosts(userId: Int?) {
        client.performRequest(with: requestData(userId: userId))
    }
    
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
    
    // MARK: - HTTPClientDelegate
    
    func success(response: Data?) {
        guard
            let responseData = response,
            let responseObject = try? JSONSerialization.jsonObject(with: responseData, options: []),
            let posts = responseObject as? [[String: Any]]
        else {
            return
        }
        
        eventListenerFactory.notifyListeners(FetchedPostsEvent(posts: posts))
    }
    
    func failure(error: Error) {
        eventListenerFactory.notifyListeners(FetchedPostsErrorEvent(error: error))
    }
}
