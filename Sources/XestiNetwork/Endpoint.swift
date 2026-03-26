// © 2018–2026 John Gary Pusey (see LICENSE.md)

public import Foundation

/// An HTTP protocol URL endpoint.
///
/// An endpoint encapsulates the information needed to construct an HTTP
/// protocol URL load request, as well as the information needed to validate the
/// resulting response.
///
/// An endpoint only represents information about the request and response. You
/// must use `URLSession` to send the HTTP request to a server and receive the
/// response.
public struct Endpoint {

    // MARK: Public Initializers

    /// Creates a new `Endpoint` instance.
    ///
    /// - Parameter baseURL:
    /// - Parameter path:
    public init(baseURL: URL,
                path: String) {
        self.baseURL = baseURL.absoluteURL
        self.path = path
    }

    /// Creates a new `Endpoint` instance.
    ///
    /// - Parameter url:
    public init?(url: URL) {
        guard var components = URLComponents(url: url,
                                             resolvingAgainstBaseURL: true)
        else { return nil }

        self.path = components.path

        components.path = ""

        guard let url = components.url
        else { return nil }

        self.baseURL = url
    }

    // MARK: Public Instance Properties

    /// The base URL with which to construct an HTTP request.
    public let baseURL: URL

    /// The URL path component with which to construct an HTTP request.
    public let path: String

    /// The set of ``ContentType`` instances with which to validate an HTTP
    /// response.
    ///
    /// The default set contains ``ContentType/json``.
    public var acceptableContentTypes: Set<ContentType> = [.json]

    /// The set of HTTP status codes with which to validate an HTTP response.
    ///
    /// The default set contains all status codes from 200 to 300 (exclusive).
    public var acceptableStatusCodes = IndexSet(200..<300)

    /// The cache policy with which to construct an HTTP request.
    ///
    /// The default cache policy is `.useProtocolCachePolicy`.
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

    /// The data source for an HTTP upload request.
    ///
    /// The default data source is `nil`.
    public var dataSource: DataSource?

    /// A dictionary of HTTP headers with which to construct an HTTP request.
    ///
    /// By default, the headers provided here are converted to a dictionary of
    /// standard string header fields for the HTTP request. You can customize or
    /// suppress the conversion by providing your own ``makeHeaderFields``
    /// closure.
    ///
    /// By default, `headers` is `nil`.
    public var headers: [HTTPHeaderName: any Sendable]?

    /// A closure that accepts an ``Endpoint`` as its argument and returns a
    /// dictionary of standard string header fields.
    ///
    /// By default, if the ``headers`` dictionary is non-`nil`, it is converted
    /// to a dictionary of standard string header fields for the HTTP request.
    ///
    /// The closure returns `nil` if it is unable to construct the header
    /// fields, or if header fields are irrelevant for the HTTP request.
    public var makeHeaderFields: @Sendable (Self) -> [String: String]? = Self._defaultMakeHeaderFields

    /// A closure that accepts an ``Endpoint`` as its argument and returns an
    /// array of new `URLQueryItem` instances.
    ///
    /// By default, if the ``parameters`` dictionary is non-`nil`. it is
    /// converted to an array of query items for the HTTP request.
    ///
    /// The closure returns `nil` if it is unable to construct the query items,
    /// or if query items are irrelevant for the HTTP request.
    public var makeQueryItems: @Sendable (Self) -> [URLQueryItem]? = Self._defaultMakeQueryItems

    /// A closure that accepts an ``Endpoint`` as its argument and returns a new
    /// `URLRequest` instance.
    ///
    /// By default, the results of calling ``makeURL`` and ``makeHeaderFields``
    /// are combined, along with the values of ``cachePolicy``,
    /// ``timeoutInterval``, and ``method``, to create the HTTP request.
    ///
    /// The closure returns `nil` if it is unable to construct the HTTP request.
    public var makeRequest: @Sendable (Self) -> URLRequest? = Self._defaultMakeRequest

    /// A closure that accepts an ``Endpoint`` as its argument and returns a new
    /// `URL` instance.
    ///
    /// By default, ``baseURL`` is resolved and combined with ``path``, as well
    /// as the result of calling ``makeQueryItems``, to form the complete URL
    /// for the HTTP request.
    ///
    /// The closure returns `nil` if it is unable to construct the URL.
    public var makeURL: @Sendable (Self) -> URL? = Self._defaultMakeURL

    /// The HTTP request method with which to construct an HTTP request.
    ///
    /// The default HTTP method is ``HTTPMethod/get``.
    public var method: HTTPMethod = .get

    /// A dictionary of parameters with which to construct an HTTP request.
    ///
    /// By default, the parameters provided here are converted to an array of
    /// query items for the HTTP request. You can customize or suppress the
    /// conversion by providing your own ``makeQueryItems`` and ``makeURL``
    /// closures.
    ///
    /// By default, `parameters` is `nil`.
    public var parameters: [ParameterName: any Sendable]?

    /// The timeout interval, in seconds, with which to construct an HTTP
    /// request.
    ///
    /// The default timeout interval is 60 seconds.
    public var timeoutInterval: TimeInterval = 60
}

// MARK: -

extension Endpoint {

    // MARK: Private Type Methods

    private static func _defaultMakeHeaderFields(_ endpoint: Endpoint) -> [String: String]? {
        guard let headers = endpoint.headers
        else { return nil }

        return Dictionary(uniqueKeysWithValues: headers.map {
            ($0.key.stringValue, String(describing: $0.value))
        })
    }

    private static func _defaultMakeQueryItems(_ endpoint: Endpoint) -> [URLQueryItem]? {
        guard let parameters = endpoint.parameters
        else { return nil }

        return parameters.map {
            URLQueryItem(name: $0.key.stringValue,
                         value: String(describing: $0.value))
        }
    }

    private static func _defaultMakeRequest(_ endpoint: Endpoint) -> URLRequest? {
        guard let url = endpoint.makeURL(endpoint)
        else { return nil }

        var request = URLRequest(url: url,
                                 cachePolicy: endpoint.cachePolicy,
                                 timeoutInterval: endpoint.timeoutInterval)

        request.allHTTPHeaderFields = endpoint.makeHeaderFields(endpoint)
        request.httpMethod = endpoint.method.stringValue

        return request
    }

    private static func _defaultMakeURL(_ endpoint: Endpoint) -> URL? {
        guard var components = URLComponents(url: endpoint.baseURL,
                                             resolvingAgainstBaseURL: true)
        else { return nil }

        components.path = (components.path as NSString).appendingPathComponent(endpoint.path)
        components.queryItems = endpoint.makeQueryItems(endpoint)

        return components.url
    }
}

// MARK: - Sendable

extension Endpoint: Sendable {
}
