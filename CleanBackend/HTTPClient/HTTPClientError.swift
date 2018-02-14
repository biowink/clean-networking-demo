enum HTTPClientError: Int, Error {
    case noHTTPResponse = 0
    case clientError = 470
    case badRequest = 400
    case unauthorized = 401
    case emailUnverifiedOrBadUserID = 403
    case notFound = 404
    case socialProfileMissingEmail = 406
    case socialProfileConflictingEmail = 409
    case badPasswordOrDuplicateEmail = 422
    case serverError = 500
    case unknown = 999
}
