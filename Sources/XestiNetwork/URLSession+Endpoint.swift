// © 2018–2024 John Gary Pusey (see LICENSE.md)

import Foundation

extension URLSession {

    // MARK: Public Instance Methods

    public func run(_ endpoint: Endpoint) async throws -> (Data, URLResponse) {
        guard let request = endpoint.makeRequest(endpoint)
        else { throw NetworkError.invalidURLRequest }

        var retData: Data?
        var location: URL?
        var response: URLResponse

        switch endpoint.task {
        case .data:
            (retData, response) = try await data(for: request)

        case .downloadData, .downloadFile:
            (location, response) = try await download(for: request)

        case let .uploadData(data):
            (retData, response) = try await upload(for: request,
                                                   from: data)

        case let .uploadFile(fileURL):
            (retData, response) = try await upload(for: request,
                                                   fromFile: fileURL)
        }

        guard let response = response as? HTTPURLResponse
        else { throw NetworkError.invalidHTTPURLResponse }

        try _checkValid(response: response,
                        for: endpoint)

        switch endpoint.task {
        case .downloadData:
            guard let srcURL = location
            else { throw NetworkError.missingLocation }

            let data = try Data(contentsOf: srcURL,
                                options: .uncached)

            return (data, response)

        case let .downloadFile(dstURL):
            guard let srcURL = location
            else { throw NetworkError.missingLocation }

            try _moveItem(at: srcURL,
                          to: dstURL)

            return (Data(), response)

        default:
            guard let retData
            else { throw NetworkError.missingData }

            return (retData, response)
        }
    }

    // MARK: Private Instance Methods

    private func _checkValid(response: HTTPURLResponse,
                             for endpoint: Endpoint) throws {
        let statusCode = response.statusCode

        if !endpoint.acceptableStatusCodes.contains(statusCode) {
            let summary = HTTPURLResponse.localizedString(forStatusCode: statusCode)

            throw NetworkError.unacceptableStatusCode(statusCode, summary)
        }

        if let contentType = response.mimeType,
           !endpoint.acceptableContentTypes.contains(ContentType(contentType)) {
            throw NetworkError.unacceptableContentType(contentType)
        }
    }

    private func _moveItem(at srcURL: URL,
                           to dstURL: URL) throws {
        let fm = FileManager.`default`

        if fm.fileExists(atPath: dstURL.path) {
            try fm.removeItem(at: dstURL)
        }

        try fm.moveItem(at: srcURL,
                        to: dstURL)
    }
}
