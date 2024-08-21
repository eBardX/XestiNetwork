// © 2018–2024 John Gary Pusey (see LICENSE.md)

import Foundation

extension URLSession {

    // MARK: Public Instance Methods

    public func bytes(for endpoint: Endpoint,
                      delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (URLSession.AsyncBytes, HTTPURLResponse) {
        let (bytes, response) = try await bytes(for: _makeRequest(for: endpoint),
                                                delegate: delegate)

        return (bytes, try _checkValidResponse(response,
                                               for: endpoint))
    }

    public func data(for endpoint: Endpoint,
                     delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await data(for: _makeRequest(for: endpoint),
                                              delegate: delegate)

        return (data, try _checkValidResponse(response,
                                              for: endpoint))
    }

    public func download(for endpoint: Endpoint,
                         delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (URL, HTTPURLResponse) {
        let (location, response) = try await download(for: _makeRequest(for: endpoint),
                                                      delegate: delegate)

        return (location, try _checkValidResponse(response,
                                                  for: endpoint))
    }

    public func upload(for endpoint: Endpoint,
                       from bodyData: Data,
                       delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await upload(for: _makeRequest(for: endpoint),
                                                from: bodyData,
                                                delegate: delegate)

        return (data, try _checkValidResponse(response,
                                              for: endpoint))
    }

    public func upload(for endpoint: Endpoint,
                       fromFile fileURL: URL,
                       delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await upload(for: _makeRequest(for: endpoint),
                                                fromFile: fileURL,
                                                delegate: delegate)

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
