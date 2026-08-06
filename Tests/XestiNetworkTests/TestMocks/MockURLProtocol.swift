// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation

// A `URLProtocol` subclass that intercepts requests and returns a
// pre-configured response, allowing `URLSession` networking tests to run
// without touching the network.
internal final class MockURLProtocol: URLProtocol, @unchecked Sendable {

    // MARK: Internal Nested Types

    internal struct Stub {
        internal var data: Data?
        internal var error: (any Error)?
        internal var response: URLResponse?
    }

    // MARK: Internal Type Methods

    internal static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral

        configuration.protocolClasses = [MockURLProtocol.self]

        return URLSession(configuration: configuration)
    }

    internal static func setStub(_ stub: Stub?) {
        lock.lock()
        defer { lock.unlock() }

        Self.stub = stub
    }

    // MARK: Private Type Properties

    private static let lock = NSLock()
    private nonisolated(unsafe) static var stub: Stub?

    // MARK: Overridden Internal Type Methods

    override internal static func canInit(with request: URLRequest) -> Bool {
        true
    }

    override internal static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    // MARK: Overridden Internal Instance Methods

    override internal func startLoading() {
        Self.lock.lock()
        let stub = Self.stub
        Self.lock.unlock()

        if let error = stub?.error {
            client?.urlProtocol(self,
                                didFailWithError: error)
            return
        }

        if let response = stub?.response {
            client?.urlProtocol(self,
                                didReceive: response,
                                cacheStoragePolicy: .notAllowed)
        }

        if let data = stub?.data {
            client?.urlProtocol(self,
                                didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override internal func stopLoading() {
    }
}
