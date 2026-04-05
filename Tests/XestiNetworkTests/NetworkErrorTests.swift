// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiNetwork

struct NetworkErrorTests {
}

// MARK: -

extension NetworkErrorTests {
    @Test
    func test_message_invalidHTTPURLResponse() {
        let error = NetworkError.invalidHTTPURLResponse

        #expect(error.message == "Invalid HTTP URL response")
    }

    @Test
    func test_message_invalidURLRequest() {
        let error = NetworkError.invalidURLRequest

        #expect(error.message == "Invalid URL request")
    }

    @Test
    func test_message_missingDataSource() {
        let error = NetworkError.missingDataSource

        #expect(error.message == "Missing data source")
    }

    @Test
    func test_message_unacceptableContentType() {
        let error = NetworkError.unacceptableContentType("text/html")

        #expect(error.message == "Unacceptable content type: text/html")
    }

    @Test
    func test_message_unacceptableStatusCode() {
        let error = NetworkError.unacceptableStatusCode(404, "not found")

        #expect(error.message == "Unacceptable status code: not found (404)")
    }
}
