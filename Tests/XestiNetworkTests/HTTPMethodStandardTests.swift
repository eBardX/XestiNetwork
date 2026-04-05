// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiNetwork

struct HTTPMethodStandardTests {
}

// MARK: -

extension HTTPMethodStandardTests {
    @Test
    func test_standardValues() {
        #expect(HTTPMethod.connect.stringValue == "CONNECT")
        #expect(HTTPMethod.delete.stringValue == "DELETE")
        #expect(HTTPMethod.get.stringValue == "GET")
        #expect(HTTPMethod.head.stringValue == "HEAD")
        #expect(HTTPMethod.options.stringValue == "OPTIONS")
        #expect(HTTPMethod.patch.stringValue == "PATCH")
        #expect(HTTPMethod.post.stringValue == "POST")
        #expect(HTTPMethod.put.stringValue == "PUT")
        #expect(HTTPMethod.trace.stringValue == "TRACE")
    }
}
