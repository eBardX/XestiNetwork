// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiNetwork

struct HTTPHeaderNameStandardTests {
}

// MARK: -

extension HTTPHeaderNameStandardTests {
    @Test
    func test_standardValues() {
        #expect(HTTPHeaderName.authorization.stringValue == "Authorization")
        #expect(HTTPHeaderName.contentType.stringValue == "Content-Type")
        #expect(HTTPHeaderName.userAgent.stringValue == "User-Agent")
    }
}
