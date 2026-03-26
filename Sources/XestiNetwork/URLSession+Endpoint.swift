// © 2018–2026 John Gary Pusey (see LICENSE.md)

public import Foundation

private import XestiTools

/// Extensions allowing `URLSession` to seemlessly use ``Endpoint`` instances.
extension URLSession {

    // MARK: Public Instance Methods

    /// Retrieves the contents of a URL described in the provided endpoint and
    /// delivers an asynchronous sequence of bytes.
    ///
    /// Use this method when you want to process the bytes while the transfer is
    /// underway. You can use a `for-await-in` loop to handle each byte. For
    /// textual data, use the `URLSession.AsyncBytes` properties `characters`,
    /// `unicodeScalars`, or `lines` to receive the content
    /// as asynchronous sequences of those types.
    ///
    /// To wait until the session finishes transferring data and receive it in a
    /// single `Data` instance, use ``data(for:delegate:)``.
    ///
    /// - Parameter endpoint:   An ``Endpoint`` instance that describes
    ///                         request-specific information such as the URL,
    ///                         cache policy, request type, and body data or
    ///                         body stream.
    /// - Parameter delegate:   A delegate that receives life cycle and
    ///                         authentication challenge callbacks as the
    ///                         transfer progresses.
    ///
    /// - Returns:  An asynchronously-delivered tuple that contains a
    ///             `URLSession.AsyncBytes` sequence to iterate over, and an
    ///             `HTTPURLResponse`.
    public func bytes(for endpoint: Endpoint,
                      delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (URLSession.AsyncBytes, HTTPURLResponse) {
        let (bytes, response) = try await bytes(for: _makeRequest(for: endpoint),
                                                delegate: delegate)

        return (bytes, try _checkValidResponse(response,
                                               for: endpoint))
    }

    /// Downloads the contents of a URL described in the provided endpoint and
    /// delivers the data asynchronously.
    ///
    /// Use this method to wait until the session finishes transferring data and
    /// receive it in a single `Data` instance. To process the bytes as the
    /// session receives them, use ``bytes(for:delegate:)``.
    ///
    /// - Parameter endpoint:   An ``Endpoint`` instance that describes
    ///                         request-specific information such as the URL,
    ///                         cache policy, request type, and body data or
    ///                         body stream.
    /// - Parameter delegate:   A delegate that receives life cycle and
    ///                         authentication challenge callbacks as the
    ///                         transfer progresses.
    ///
    /// - Returns:  An asynchronously-delivered tuple that contains the URL
    ///             contents as a `Data` instance, and an `HTTPURLResponse`.
    public func data(for endpoint: Endpoint,
                     delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await data(for: _makeRequest(for: endpoint),
                                              delegate: delegate)

        return (data, try _checkValidResponse(response,
                                              for: endpoint))
    }

    /// Retrieves the contents of a URL described in the provided endpoint and
    /// delivers the URL of the saved file asynchronously.
    ///
    /// - Parameter endpoint:   An ``Endpoint`` instance that describes
    ///                         request-specific information such as the URL,
    ///                         cache policy, request type, and body data or
    ///                         body stream.
    /// - Parameter delegate:   A delegate that receives life cycle and
    ///                         authentication challenge callbacks as the
    ///                         transfer progresses.
    ///
    /// - Returns:  An asynchronously-delivered tuple that contains the location
    ///             of the downloaded file as a URL, and an `HTTPURLResponse`.
    public func download(for endpoint: Endpoint,
                         delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (URL, HTTPURLResponse) {
        let (location, response) = try await download(for: _makeRequest(for: endpoint),
                                                      delegate: delegate)

        return (location, try _checkValidResponse(response,
                                                  for: endpoint))
    }

    /// Uploads data to a URL described in the provided endpoint and delivers
    /// the result asynchronously.
    ///
    /// - Parameter endpoint:   An ``Endpoint`` instance that describes
    ///                         request-specific information such as the URL,
    ///                         cache policy, request type, and body data or
    ///                         body stream.
    /// - Parameter delegate:   A delegate that receives life cycle and
    ///                         authentication challenge callbacks as the
    ///                         transfer progresses.
    ///
    /// - Returns:  An asynchronously-delivered tuple that contains any data
    ///             returned by the server as a `Data` instance, and an
    ///             `HTTPURLResponse`.
    public func upload(for endpoint: Endpoint,
                       delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        guard let dataSource = endpoint.dataSource
        else { throw NetworkError.missingDataSource }

        let response: URLResponse
        let data: Data

        switch dataSource {
        case let .bodyData(bodyData):
            (data, response) = try await upload(for: _makeRequest(for: endpoint),
                                                from: bodyData,
                                                delegate: delegate)

        case let .fileURL(fileURL):
            (data, response) = try await upload(for: _makeRequest(for: endpoint),
                                                fromFile: fileURL,
                                                delegate: delegate)
        }

        return (data, try _checkValidResponse(response,
                                              for: endpoint))
    }

    // MARK: Private Instance Methods

    private func _checkValidResponse(_ response: URLResponse,
                                     for endpoint: Endpoint) throws -> HTTPURLResponse {
        guard let response = response as? HTTPURLResponse
        else { throw NetworkError.invalidHTTPURLResponse }

        let statusCode = response.statusCode

        if !endpoint.acceptableStatusCodes.contains(statusCode) {
            let summary = HTTPURLResponse.localizedString(forStatusCode: statusCode)

            throw NetworkError.unacceptableStatusCode(statusCode, summary)
        }

        if let contentType = response.mimeType,
           !endpoint.acceptableContentTypes.contains(ContentType(contentType)) {
            throw NetworkError.unacceptableContentType(contentType)
        }

        return response
    }

    private func _makeRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard let request = endpoint.makeRequest(endpoint)
        else { throw NetworkError.invalidURLRequest }

        return request
    }
}
