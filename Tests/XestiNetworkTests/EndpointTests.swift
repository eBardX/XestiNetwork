// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
@testable import XestiNetwork
import XestiTools

struct EndpointTests {
}

// MARK: -

extension EndpointTests {
    @Test
    func test_customMakeURL() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let customURL = try #require(URL(string: "https://custom.example.com/override"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.makeURL = { _ in customURL }

        let url = try #require(endpoint.makeURL(endpoint))

        #expect(url == customURL)
    }

    @Test
    func test_defaultPropertyValues() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")

        #expect(endpoint.acceptableContentTypes == [.json])
        #expect(endpoint.acceptableStatusCodes == IndexSet(200..<300))
        #expect(endpoint.cachePolicy == .useProtocolCachePolicy)
        #expect(endpoint.dataSource == nil)
        #expect(endpoint.headers == nil)
        #expect(endpoint.method == .get)
        #expect(endpoint.parameters == nil)
        #expect(endpoint.timeoutInterval == 60)
    }

    @Test
    func test_initWithBaseURLAndPath() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/v1/users")

        #expect(endpoint.baseURL == baseURL)
        #expect(endpoint.path == "/v1/users")
    }

    @Test
    func test_initWithURL() throws {
        let url = try #require(URL(string: "https://api.example.com/v1/users"))
        let endpoint = try #require(Endpoint(url: url))

        #expect(endpoint.path == "/v1/users")

        let reconstructedURL = try #require(endpoint.makeURL(endpoint))

        #expect(reconstructedURL.absoluteString == "https://api.example.com/v1/users")
    }

    @Test
    func test_makeHeaderFieldsReturnsNilWithoutHeaders() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")

        #expect(endpoint.makeHeaderFields(endpoint) == nil)
    }

    @Test
    func test_makeHeaderFieldsWithHeaders() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.headers = [.authorization: "Bearer token123"]

        let fields = try #require(endpoint.makeHeaderFields(endpoint))

        #expect(fields["Authorization"] == "Bearer token123")
    }

    @Test
    func test_makeHeaderFieldsWithMultipleHeaders() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.headers = [.authorization: "Bearer token",
                            .contentType: "application/json",
                            .userAgent: "TestApp/1.0"]

        let fields = try #require(endpoint.makeHeaderFields(endpoint))

        #expect(fields.count == 3)
        #expect(fields["Authorization"] == "Bearer token")
        #expect(fields["Content-Type"] == "application/json")
        #expect(fields["User-Agent"] == "TestApp/1.0")
    }

    @Test
    func test_makeQueryItemsReturnsNilWithoutParameters() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")

        #expect(endpoint.makeQueryItems(endpoint) == nil)
    }

    @Test
    func test_makeQueryItemsWithParameters() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.parameters = [ParameterName("page"): "1"]

        let items = try #require(endpoint.makeQueryItems(endpoint))

        #expect(items.count == 1)
        #expect(items.first?.name == "page")
        #expect(items.first?.value == "1")
    }

    @Test
    func test_makeRequest() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/v1/users")
        let request = try #require(endpoint.makeRequest(endpoint))

        #expect(request.url?.absoluteString == "https://api.example.com/v1/users")
        #expect(request.httpMethod == "GET")
    }

    @Test
    func test_makeRequestCombinesAllProperties() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/v1/items")

        endpoint.method = .put
        endpoint.timeoutInterval = 90
        endpoint.cachePolicy = .returnCacheDataElseLoad
        endpoint.headers = [.authorization: "Bearer abc"]
        endpoint.parameters = [ParameterName("id"): "42"]

        let request = try #require(endpoint.makeRequest(endpoint))

        #expect(request.httpMethod == "PUT")
        #expect(request.timeoutInterval == 90)
        #expect(request.cachePolicy == .returnCacheDataElseLoad)
        #expect(request.allHTTPHeaderFields?["Authorization"] == "Bearer abc")

        let requestURL = try #require(request.url)
        let components = try #require(URLComponents(url: requestURL,
                                                    resolvingAgainstBaseURL: true))

        #expect(components.queryItems?.first?.name == "id")
        #expect(components.queryItems?.first?.value == "42")
    }

    @Test
    func test_makeRequestReturnsNilWhenMakeURLFails() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.makeURL = { _ in nil }

        #expect(endpoint.makeRequest(endpoint) == nil)
    }

    @Test
    func test_makeRequestSetsCachePolicy() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.cachePolicy = .reloadIgnoringLocalCacheData

        let request = try #require(endpoint.makeRequest(endpoint))

        #expect(request.cachePolicy == .reloadIgnoringLocalCacheData)
    }

    @Test
    func test_makeRequestSetsHTTPMethod() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/v1/users")

        endpoint.method = .post

        let request = try #require(endpoint.makeRequest(endpoint))

        #expect(request.httpMethod == "POST")
    }

    @Test
    func test_makeRequestSetsHeaderFields() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.headers = [.contentType: "application/json"]

        let request = try #require(endpoint.makeRequest(endpoint))

        #expect(request.allHTTPHeaderFields?["Content-Type"] == "application/json")
    }

    @Test
    func test_makeRequestSetsTimeoutInterval() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.timeoutInterval = 120

        let request = try #require(endpoint.makeRequest(endpoint))

        #expect(request.timeoutInterval == 120)
    }

    @Test
    func test_makeURL() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/v1/users")
        let url = try #require(endpoint.makeURL(endpoint))

        #expect(url.absoluteString == "https://api.example.com/v1/users")
    }

    @Test
    func test_makeURLWithMultipleParameters() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/search")

        endpoint.parameters = [ParameterName("q"): "swift",
                               ParameterName("page"): "2"]

        let url = try #require(endpoint.makeURL(endpoint))
        let components = try #require(URLComponents(url: url,
                                                    resolvingAgainstBaseURL: true))
        let items = try #require(components.queryItems)

        #expect(items.count == 2)

        let names = Set(items.map(\.name))

        #expect(names.contains("q"))
        #expect(names.contains("page"))
    }

    @Test
    func test_makeURLWithParameters() throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))

        var endpoint = Endpoint(baseURL: baseURL, path: "/search")

        endpoint.parameters = [ParameterName("q"): "swift"]

        let url = try #require(endpoint.makeURL(endpoint))
        let components = try #require(URLComponents(url: url,
                                                    resolvingAgainstBaseURL: true))

        #expect(components.queryItems?.count == 1)
        #expect(components.queryItems?.first?.name == "q")
        #expect(components.queryItems?.first?.value == "swift")
    }
}
