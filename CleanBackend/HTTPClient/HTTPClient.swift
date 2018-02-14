protocol HTTPClientDelegate: class {
    func success(response: Data?)
    func failure(error: Error)
}

public final class HTTPClient: HTTPStatusCodeHandling, HTTPClientProviding {
    private let session: URLSessionProtocol
    private let dataTaskBuilder: DataTaskBuilder
    weak var delegate: HTTPClientDelegate?

    public convenience init(configuration: RequestConfiguration) {
        self.init(configuration: configuration, sessionProvider: DefaultURLSessionProvider())
    }

    init(configuration: RequestConfiguration, sessionProvider: URLSessionProviding) {
        session = sessionProvider.session()
        dataTaskBuilder = DataTaskBuilder(urlSession: session, baseUrl: configuration.baseUrl)
    }
    
    func performRequest(with requestData: RequestData) {
        let task = dataTaskBuilder.task(from: requestData) { (data, response, error) in
            if let error = error {
                self.delegate?.failure(error: error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                self.delegate?.failure(error: HTTPClientError.noHTTPResponse)
                return
            }
            
            if self.isSuccessStatus(statusCode: httpResponse.statusCode) {
                self.delegate?.success(response: data)
            } else {
                let responseError = self.error(forHTTPStatus: httpResponse.statusCode)
                self.delegate?.failure(error: responseError)
            }
        }
        task?.resume()
    }
}
