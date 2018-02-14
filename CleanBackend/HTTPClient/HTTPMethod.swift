enum HTTPMethod: String {
    case get
    case put
    case post
    case patch
    case delete
    
    var stringRepresentation: String {
        return self.rawValue.uppercased()
    }
}
