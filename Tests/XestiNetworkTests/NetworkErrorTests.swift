// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiNetwork

struct NetworkErrorTests {
}

// MARK: -

extension NetworkErrorTests {
    @Test
    func test_invalidHTTPURLResponseMessage() {
        let error = NetworkError.invalidHTTPURLResponse

        #expect(error.message == "Invalid HTTP URL response")
    }

    @Test
    func test_invalidURLRequestMessage() {
        let error = NetworkError.invalidURLRequest

        #expect(error.message == "Invalid URL request")
    }

    @Test
    func test_missingDataSourceMessage() {
        let error = NetworkError.missingDataSource

        #expect(error.message == "Missing data source")
    }

    @Test
    func test_unacceptableContentTypeMessage() {
        let error = NetworkError.unacceptableContentType("text/html")

        #expect(error.message == "Unacceptable content type: text/html")
    }

    @Test
    func test_unacceptableStatusCodeMessage() {
        let error = NetworkError.unacceptableStatusCode(404, "not found")

        #expect(error.message == "Unacceptable status code: not found (404)")
    }
}
