// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
@testable import XestiNetwork

@Suite(.serialized)
struct URLSessionEndpointTests {
}

// MARK: -

extension URLSessionEndpointTests {
    @Test
    func bytes_success() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")
        let session = MockURLProtocol.makeSession()
        let expectedData = Data("streamed".utf8)

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: expectedData,
                                                     response: makeHTTPURLResponse(url: baseURL)))

        defer { MockURLProtocol.setStub(nil) }

        let (bytes, response) = try await session.bytes(for: endpoint)
        var collected = [UInt8]()

        for try await byte in bytes {
            collected.append(byte)
        }

        #expect(Data(collected) == expectedData)
        #expect(response.statusCode == 200)
    }

    @Test
    func bytes_unacceptableStatusCode() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")
        let session = MockURLProtocol.makeSession()

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: Data(),
                                                     response: makeHTTPURLResponse(url: baseURL,
                                                                                   statusCode: 500)))

        defer { MockURLProtocol.setStub(nil) }

        await #expect(throws: NetworkError.self) {
            _ = try await session.bytes(for: endpoint)
        }
    }

    @Test
    func data_invalidHTTPURLResponse() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")
        let session = MockURLProtocol.makeSession()
        let nonHTTPResponse = URLResponse(url: baseURL,
                                          mimeType: nil,
                                          expectedContentLength: 0,
                                          textEncodingName: nil)

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: Data(),
                                                     response: nonHTTPResponse))

        defer { MockURLProtocol.setStub(nil) }

        await #expect(throws: NetworkError.self) {
            _ = try await session.data(for: endpoint)
        }
    }

    @Test
    func data_invalidURLRequest() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let session = MockURLProtocol.makeSession()

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.makeURL = { _ in nil }

        await #expect(throws: NetworkError.self) {
            _ = try await session.data(for: endpoint)
        }
    }

    @Test
    func data_success() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")
        let session = MockURLProtocol.makeSession()
        let expectedData = Data("{\"ok\":true}".utf8)

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: expectedData,
                                                     response: makeHTTPURLResponse(url: baseURL)))

        defer { MockURLProtocol.setStub(nil) }

        let (data, response) = try await session.data(for: endpoint)

        #expect(data == expectedData)
        #expect(response.statusCode == 200)
    }

    @Test
    func data_unacceptableContentType() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")
        let session = MockURLProtocol.makeSession()

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: Data(),
                                                     response: makeHTTPURLResponse(url: baseURL,
                                                                                   contentType: "text/html")))

        defer { MockURLProtocol.setStub(nil) }

        await #expect(throws: NetworkError.self) {
            _ = try await session.data(for: endpoint)
        }
    }

    @Test
    func data_unacceptableStatusCode() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")
        let session = MockURLProtocol.makeSession()

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: Data(),
                                                     response: makeHTTPURLResponse(url: baseURL,
                                                                                   statusCode: 404)))

        defer { MockURLProtocol.setStub(nil) }

        await #expect(throws: NetworkError.self) {
            _ = try await session.data(for: endpoint)
        }
    }

    @Test
    func download_success() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")
        let session = MockURLProtocol.makeSession()
        let expectedData = Data("downloaded".utf8)

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: expectedData,
                                                     response: makeHTTPURLResponse(url: baseURL)))

        defer { MockURLProtocol.setStub(nil) }

        let (location, response) = try await session.download(for: endpoint)

        defer { try? FileManager.default.removeItem(at: location) }

        let downloadedData = try Data(contentsOf: location)

        #expect(downloadedData == expectedData)
        #expect(response.statusCode == 200)
    }

    @Test
    func download_unacceptableStatusCode() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")
        let session = MockURLProtocol.makeSession()

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: Data(),
                                                     response: makeHTTPURLResponse(url: baseURL,
                                                                                   statusCode: 503)))

        defer { MockURLProtocol.setStub(nil) }

        await #expect(throws: NetworkError.self) {
            _ = try await session.download(for: endpoint)
        }
    }

    @Test
    func upload_bodyData() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let session = MockURLProtocol.makeSession()
        let expectedData = Data("uploaded".utf8)

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.dataSource = .bodyData(Data("payload".utf8))

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: expectedData,
                                                     response: makeHTTPURLResponse(url: baseURL)))

        defer { MockURLProtocol.setStub(nil) }

        let (data, response) = try await session.upload(for: endpoint)

        #expect(data == expectedData)
        #expect(response.statusCode == 200)
    }

    @Test
    func upload_fileURL() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let session = MockURLProtocol.makeSession()
        let expectedData = Data("uploaded".utf8)
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)

        try Data("payload".utf8).write(to: fileURL)

        defer { try? FileManager.default.removeItem(at: fileURL) }

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.dataSource = .fileURL(fileURL)

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: expectedData,
                                                     response: makeHTTPURLResponse(url: baseURL)))

        defer { MockURLProtocol.setStub(nil) }

        let (data, response) = try await session.upload(for: endpoint)

        #expect(data == expectedData)
        #expect(response.statusCode == 200)
    }

    @Test
    func upload_missingDataSource() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/test")
        let session = MockURLProtocol.makeSession()

        await #expect(throws: NetworkError.self) {
            _ = try await session.upload(for: endpoint)
        }
    }

    @Test
    func upload_unacceptableStatusCode() async throws {
        let baseURL = try #require(URL(string: "https://api.example.com"))
        let session = MockURLProtocol.makeSession()

        var endpoint = Endpoint(baseURL: baseURL, path: "/test")

        endpoint.dataSource = .bodyData(Data("payload".utf8))

        MockURLProtocol.setStub(MockURLProtocol.Stub(data: Data(),
                                                     response: makeHTTPURLResponse(url: baseURL,
                                                                                   statusCode: 400)))

        defer { MockURLProtocol.setStub(nil) }

        await #expect(throws: NetworkError.self) {
            _ = try await session.upload(for: endpoint)
        }
    }
}
