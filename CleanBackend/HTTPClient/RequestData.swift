struct RequestData {
    let method: HTTPMethod
    let path: String
    let body: [String: Any]?
    let parameters: [String: String]?
    
    init(method: HTTPMethod, path: String, parameters: [String: String]? = nil, body: [String: Any]? = nil) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.body = body
    }
}
