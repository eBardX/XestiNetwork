// © 2018–2026 John Gary Pusey (see LICENSE.md)

/// An error that occurs while constructing an HTTP request or while
/// validating an HTTP response.
public enum NetworkError: Error {
    /// A `URLResponse` instance could not be downcast to `HTTPURLResponse`.
    case invalidHTTPURLResponse

    /// A call to ``Endpoint/makeRequest`` returned `nil`.
    case invalidURLRequest

    /// A call to `URLSession.upload(for:delegate:)` was made on an endpoint
    /// with its ``Endpoint/dataSource`` set to `nil`.
    case missingDataSource

    /// An HTTP response has an unacceptable content type.
    ///
    /// As an associated value, this case contains the unacceptable content type
    /// as a string value.
    case unacceptableContentType(String)

    /// An HTTP response has an unacceptable status code.
    ///
    /// As associated values, this case contains the unacceptable status code
    /// both as an integer value and as a localized string value.
    case unacceptableStatusCode(Int, String)
}

// MARK: - Sendable

extension NetworkError: Sendable {
}
