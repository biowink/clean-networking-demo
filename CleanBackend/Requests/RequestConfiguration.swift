public struct RequestConfiguration {
    let baseUrl: URL
    
    // Any information needed for each request should be added here.
    // e.g.: a way to access user credentials, pinned certificates, additional meta data for header fields
    
    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
}
