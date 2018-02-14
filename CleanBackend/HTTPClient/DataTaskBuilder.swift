final class DataTaskBuilder: URLBuilding {
    private let contentTypeHeaderKey = "Content-Type"
    private let jsonContentType = "application/json"
    
    private let urlSession: URLSessionProtocol
    private let baseUrl: URL
    
    init(urlSession: URLSessionProtocol, baseUrl: URL) {
        self.urlSession = urlSession
        self.baseUrl = baseUrl
    }
    
    func task(from requestData: RequestData, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol? {
        guard let request = urlRequest(from: requestData) else {
            return nil
        }
        
        return urlSession.dataTask(with: request,
                                   completionHandler: completionHandler)
    }
    
    private func urlRequest(from requestData: RequestData) -> URLRequest? {
        guard let url = buildUrl(fromBaseUrl: baseUrl, path: requestData.path, parameters: requestData.parameters) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestData.method.stringRepresentation
        
        addContentTypeHeader(&urlRequest)
        addBody(requestData, &urlRequest)

        return urlRequest
    }
    
    private func addContentTypeHeader(_ urlRequest: inout URLRequest) {
        urlRequest.setValue(jsonContentType, forHTTPHeaderField: contentTypeHeaderKey)
    }
    
    private func addBody(_ requestData: RequestData, _ urlRequest: inout URLRequest) {
        if let body = requestData.body {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
    }
}
