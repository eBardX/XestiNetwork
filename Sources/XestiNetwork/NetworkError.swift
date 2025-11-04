// © 2018–2025 John Gary Pusey (see LICENSE.md)

public enum NetworkError: Error {
    case invalidHTTPURLResponse
    case invalidURLRequest
    case missingDataSource
    case unacceptableContentType(String)
    case unacceptableStatusCode(Int, String)
}

// MARK: - Sendable

extension NetworkError: Sendable {
}
