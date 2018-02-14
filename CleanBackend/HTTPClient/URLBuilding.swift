protocol URLBuilding {}

extension URLBuilding {
    func buildUrl(fromBaseUrl baseUrl: URL, path: String, parameters: [String: String]?) -> URL? {
        
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        appendPath(path: path, toComponents: &components)
        appendParameters(parameters: parameters, toComponents: &components)
        
        return components.url
    }
    
    private func appendPath(path: String, toComponents components: inout URLComponents) {
        if path.hasPrefix("/") {
            components.path = path
        } else {
            components.path = "/\(path)"
        }
    }
    
    private func appendParameters(parameters: [String: String]?, toComponents components: inout URLComponents) {
        
        guard let parameters = parameters, !parameters.isEmpty else {
            return
        }
        
        var queryItems = [URLQueryItem]()
        
        for parameter in parameters {
            queryItems.append(URLQueryItem(name: parameter.key, value: parameter.value))
        }
        
        components.queryItems = queryItems
    }
}
