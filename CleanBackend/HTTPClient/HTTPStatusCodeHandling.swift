protocol HTTPStatusCodeHandling {
    func error(forHTTPStatus statusCode: Int) -> HTTPClientError
    func isSuccessStatus(statusCode: Int) -> Bool
}

extension HTTPStatusCodeHandling {
    func error(forHTTPStatus statusCode: Int) -> HTTPClientError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .emailUnverifiedOrBadUserID
        case 404: return .notFound
        case 406: return .socialProfileMissingEmail
        case 409: return .socialProfileConflictingEmail
        case 422: return .badPasswordOrDuplicateEmail
        case 402...499: return .clientError
        case 500...599: return .serverError
        default: return .unknown
        }
    }
    
    func isSuccessStatus(statusCode: Int) -> Bool {
        return (200...299).contains(statusCode)
    }
}
