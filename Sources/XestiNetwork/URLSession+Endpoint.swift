// © 2018 J. G. Pusey (see LICENSE.md)

import Foundation

public extension URLSession {

    // MARK: Public Instance Methods

    private func handleResult(for endpoint: Endpoint,
                              data: Data?,
                              response: URLResponse?,
                              error: Error?,
                              completion: @escaping (NetworkResult) -> Void) {
        let result = makeResult(for: endpoint,
                                data: data,
                                response: response,
                                error: error)

        completion(result)
    }

    private func handleResult(for endpoint: Endpoint,
                              location: URL?,
                              response: URLResponse?,
                              error: Error?,
                              completion: @escaping (NetworkResult) -> Void) {
        let result = makeResult(for: endpoint,
                                location: location,
                                response: response,
                                error: error)

        completion(result)
    }

    func task(for endpoint: Endpoint,
              completion: @escaping (NetworkResult) -> Void) throws -> URLSessionTask {
        guard
            var request = endpoint.makeRequest()
            else { throw NetworkError.invalidURLRequest }

        switch endpoint.task {
        case .data:
            return dataTask(with: request) { [weak self] in
                self?.handleResult(for: endpoint,
                                   data: $0,
                                   response: $1,
                                   error: $2,
                                   completion: completion)
            }

        case .downloadData,
             .downloadFile:
            return downloadTask(with: request) { [weak self] in
                self?.handleResult(for: endpoint,
                                   location: $0,
                                   response: $1,
                                   error: $2,
                                   completion: completion)
            }

        case let .uploadData(data):
            request.httpBody = data // this is a hack so that trace works

            return uploadTask(with: request,
                              from: data) { [weak self] in
                                self?.handleResult(for: endpoint,
                                                   data: $0,
                                                   response: $1,
                                                   error: $2,
                                                   completion: completion)
            }

        case let .uploadFile(fileURL):
            return uploadTask(with: request,
                              fromFile: fileURL) { [weak self] in
                                self?.handleResult(for: endpoint,
                                                   data: $0,
                                                   response: $1,
                                                   error: $2,
                                                   completion: completion)
            }
        }
    }

    // MARK: Private Instance Methods

    private func checkValid(response: HTTPURLResponse,
                            for endpoint: Endpoint) -> Error? {
        let statusCode = response.statusCode

        if !endpoint.acceptableStatusCodes.contains(statusCode) {
            let summary = HTTPURLResponse.localizedString(forStatusCode: statusCode)

            return NetworkError.unacceptableStatusCode(statusCode, summary)
        }

        if let contentType = response.mimeType,
            !endpoint.acceptableContentTypes.contains(ContentType(contentType)) {
            return NetworkError.unacceptableContentType(contentType)
        }

        return nil
    }

    private func makeResult(for endpoint: Endpoint,
                            data: Data?,
                            response: URLResponse?,
                            error: Error?) -> NetworkResult {
        if let error = error {
            return .failure(error)
        }

        guard
            let response = response as? HTTPURLResponse
            else { return .failure(NetworkError.invalidHTTPURLResponse) }

        if let error = checkValid(response: response,
                                  for: endpoint) {
            return .failure(error)
        }

        guard
            let data = data
            else { return .failure(NetworkError.missingData) }

        return .success(data, response)
    }

    private func makeResult(for endpoint: Endpoint,
                            location: URL?,
                            response: URLResponse?,
                            error: Error?) -> NetworkResult {
        if let error = error {
            return .failure(error)
        }

        guard
            let response = response as? HTTPURLResponse
            else { return .failure(NetworkError.invalidHTTPURLResponse) }

        if let error = checkValid(response: response,
                                  for: endpoint) {
            return .failure(error)
        }

        guard
            let srcURL = location
            else { return .failure(NetworkError.missingLocation) }

        switch endpoint.task {
        case .downloadData:
            do {
                let data = try Data(contentsOf: srcURL,
                                    options: .uncached)

                return .success(data, response)
            } catch {
                return .failure(error)
            }

        case let .downloadFile(dstURL):
            if let error = moveItem(at: srcURL,
                                    to: dstURL) {
                return .failure(error)
            }

            return .success(Data(), response)

        default:
            return .failure(NetworkError.invalidURLRequest)
        }
    }

    private func moveItem(at srcURL: URL,
                          to dstURL: URL) -> Error? {
        let fm = FileManager.`default`

        do {
            if fm.fileExists(atPath: dstURL.path) {
                try fm.removeItem(at: dstURL)
            }

            try fm.moveItem(at: srcURL,
                            to: dstURL)
        } catch {
            return error
        }

        return nil
    }
}
