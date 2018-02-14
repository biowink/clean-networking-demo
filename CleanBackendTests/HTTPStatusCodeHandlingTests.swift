import XCTest
@testable import CleanBackend

class HTTPStatusCodeHandlingTests: XCTestCase {
    private let sut = StubHTTPErrorProvider()

    func test_error_code400_returnsBadRequest() {
        XCTAssertEqual(.badRequest, sut.error(forHTTPStatus: 400))
    }

    func test_error_code401_returnsUnauthorized() {
        XCTAssertEqual(.unauthorized, sut.error(forHTTPStatus: 401))
    }

    func test_error_code403_returnsEmailUnverifiedOrBadUserID() {
        XCTAssertEqual(.emailUnverifiedOrBadUserID, sut.error(forHTTPStatus: 403))
    }

    func test_error_code404_returnsNotFound() {
        XCTAssertEqual(.notFound, sut.error(forHTTPStatus: 404))
    }

    func test_error_code406_returnsSocialProfileMissingEmail() {
        XCTAssertEqual(.socialProfileMissingEmail, sut.error(forHTTPStatus: 406))
    }

    func test_error_code409_returnsSocialProfileConflictingEmail() {
        XCTAssertEqual(.socialProfileConflictingEmail, sut.error(forHTTPStatus: 409))
    }

    func test_error_code422_returnsBadPasswordOrDuplicateEmail() {
        XCTAssertEqual(.badPasswordOrDuplicateEmail, sut.error(forHTTPStatus: 422))
    }

    func test_error_other4XXCodes_returnClientError() {
        XCTAssertEqual(.clientError, sut.error(forHTTPStatus: 413))
    }

    func test_5xx_statusCodes_generate_serverError() {
        XCTAssertEqual(sut.error(forHTTPStatus: 500), HTTPClientError.serverError)
        XCTAssertEqual(sut.error(forHTTPStatus: 599), HTTPClientError.serverError)
    }
    
    func test_error_code901_returnsUnknownError() {
        XCTAssertEqual(.unknown, sut.error(forHTTPStatus: 901))
    }

    func test_error_code399_returnsUnknownError() {
        XCTAssertEqual(.unknown, sut.error(forHTTPStatus: 399))
    }

    func test_2xx_statusCodes_areSuccess() {
        XCTAssertTrue(sut.isSuccessStatus(statusCode: 200))
        XCTAssertTrue(sut.isSuccessStatus(statusCode: 299))
    }

    func test_non_2xx_statusCodes_areNotSuccess() {
        XCTAssertFalse(sut.isSuccessStatus(statusCode: 321))
        XCTAssertFalse(sut.isSuccessStatus(statusCode: 418))
        XCTAssertFalse(sut.isSuccessStatus(statusCode: 523))
    }
}

class StubHTTPErrorProvider: HTTPStatusCodeHandling { }
