// © 2018 J. G. Pusey (see LICENSE.md)

import Foundation

public struct Endpoint {

    // MARK: Public Initializers

    public init(baseURL: URL,
                path: String) {
        self.baseURL = baseURL.absoluteURL
        self.path = path
    }

    public init?(url: URL) {
        guard
            var components = URLComponents(url: url,
                                           resolvingAgainstBaseURL: true)
            else { return nil }

        self.path = components.path

        components.path = ""

        guard
            let url = components.url
            else { return nil }

        self.baseURL = url
    }

    // MARK: Public Instance Properties

    public let baseURL: URL
    public let path: String

    public var acceptableContentTypes: Set<ContentType> = [.json]
    public var acceptableStatusCodes: Range<Int> = 200..<300
    public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    public var headers: [HTTPHeaderName: Any]?
    public var method: HTTPMethod = .get
    public var parameters: [ParameterName: Any]?
    public var task: HTTPTask = .data
    public var timeoutInterval: TimeInterval = 60
    public var trace: Bool = false
}

public extension Endpoint {

    // MARK: Internal Instance Methods

    internal func makeHeaderFields() -> [String: String]? {
        guard
            let headers = headers
            else { return nil }

        var headerFields: [String: String] = [:]

        for (name, value) in headers {
            headerFields[name.rawValue] = String(describing: value)
        }

        return headerFields
    }

    internal func makeQueryItems() -> [URLQueryItem]? {
        guard
            let parameters = parameters
            else { return nil }

        var queryItems: [URLQueryItem] = []

        for (name, value) in parameters {
            queryItems.append(URLQueryItem(name: name.rawValue,
                                           value: String(describing: value)))
        }

        return queryItems
    }

    internal func makeRequest() -> URLRequest? {
        guard
            let url = makeURL()
            else { return nil }

        var request = URLRequest(url: url,
                                 cachePolicy: cachePolicy,
                                 timeoutInterval: timeoutInterval)

        request.allHTTPHeaderFields = makeHeaderFields()
        request.httpMethod = method.rawValue

        return request
    }

    internal func makeURL() -> URL? {
        guard
            var components = URLComponents(url: baseURL,
                                           resolvingAgainstBaseURL: true)
            else { return nil }

        components.path = (components.path as NSString).appendingPathComponent(path)
        components.queryItems = makeQueryItems()

        return components.url
    }
}
