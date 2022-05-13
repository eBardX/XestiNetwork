// © 2018–2022 J. G. Pusey (see LICENSE.md)

import Foundation

public struct Endpoint {

    // MARK: Public Initializers

    public init(baseURL: URL,
                path: String) {
        self.baseURL = baseURL.absoluteURL
        self.path = path
    }

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

    public let baseURL: URL
    public let path: String

    public var acceptableContentTypes: Set<ContentType> = [.json]
    public var acceptableStatusCodes = IndexSet(200..<300)
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    public var headers: [HTTPHeaderName: Any]?
    public var makeHeaderFields: (Endpoint) -> [String: String]? = _defaultMakeHeaderFields
    public var makeQueryItems: (Endpoint) -> [URLQueryItem]? = _defaultMakeQueryItems
    public var makeRequest: (Endpoint) -> URLRequest? = _defaultMakeRequest
    public var makeURL: (Endpoint) -> URL? = _defaultMakeURL
    public var method: HTTPMethod = .get
    public var parameters: [ParameterName: Any]?
    public var task: HTTPTask = .data
    public var timeoutInterval: TimeInterval = 60
    public var trace = false
}

// MARK: -

public extension Endpoint {

    // MARK: Internal Instance Methods

    private static func _defaultMakeHeaderFields(_ endpoint: Endpoint) -> [String: String]? {
        guard let headers = endpoint.headers
        else { return nil }

        var headerFields: [String: String] = [:]

        for (name, value) in headers {
            headerFields[name.rawValue] = String(describing: value)
        }

        return headerFields
    }

    private static func _defaultMakeQueryItems(_ endpoint: Endpoint) -> [URLQueryItem]? {
        guard let parameters = endpoint.parameters
        else { return nil }

        var queryItems: [URLQueryItem] = []

        for (name, value) in parameters {
            queryItems.append(URLQueryItem(name: name.rawValue,
                                           value: String(describing: value)))
        }

        return queryItems
    }

    private static func _defaultMakeRequest(_ endpoint: Endpoint) -> URLRequest? {
        guard let url = endpoint.makeURL(endpoint)
        else { return nil }

        var request = URLRequest(url: url,
                                 cachePolicy: endpoint.cachePolicy,
                                 timeoutInterval: endpoint.timeoutInterval)

        request.allHTTPHeaderFields = endpoint.makeHeaderFields(endpoint)
        request.httpMethod = endpoint.method.rawValue

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
