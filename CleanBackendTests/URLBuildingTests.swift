import XCTest
@testable import CleanBackend

final class URLBuildingTests: XCTestCase {
    private let sut = DefaultURLBuilder()
    private let baseUrl = URL(string: "http://xxx.yyy.com")!
    
    func test_buildUrlWithNilParameters_returnsBaseUrlWithPath() {
        let url = sut.buildUrl(fromBaseUrl: baseUrl, path: "zzz", parameters: nil)
        XCTAssertEqual("http://xxx.yyy.com/zzz", url?.absoluteString)
    }
    
    func test_buildUrlWithEmptyParameters_returnsBaseUrlWithPath() {
        let url = sut.buildUrl(fromBaseUrl: baseUrl, path: "/zzz", parameters: [:])
        XCTAssertEqual("http://xxx.yyy.com/zzz", url?.absoluteString)
    }
    
    func test_buildUrlWith1Parameter_returnsUrlWithPathAnd1Parameter() {
        let url = sut.buildUrl(fromBaseUrl: baseUrl,
                               path: "/zzz",
                               parameters: ["k1": "v1"])
        XCTAssertEqual("http://xxx.yyy.com/zzz?k1=v1", url?.absoluteString)
    }
    
    func test_buildUrlWith2Parameters_returnsUrlWithPathAnd2Parameters() {
        let url = sut.buildUrl(fromBaseUrl: baseUrl,
                               path: "/zzz",
                               parameters: ["k1": "v1",
                                            "k2": "v2"])

        // Constructing the url does not preserve the order of parameters, so a direct comparison to a string is not possible
        //        XCTAssertEqual("http://xxx.yyy.com/zzz?k1=v1&k2=v2", url?.absoluteString)
        
        XCTAssertNotNil(url)
        
        let urlString = url!.absoluteString
        XCTAssertTrue(urlString.hasPrefix("http://xxx.yyy.com/zzz?"))
        XCTAssertTrue(urlString.contains("&"))
        XCTAssertTrue(urlString.contains("k1=v1"))
        XCTAssertTrue(urlString.contains("k2=v2"))
    }
}

final class DefaultURLBuilder: URLBuilding {}
