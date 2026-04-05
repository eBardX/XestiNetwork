// © 2026 John Gary Pusey (see LICENSE.md)

import Testing
@testable import XestiNetwork

struct ContentTypeStandardTests {
}

// MARK: -

extension ContentTypeStandardTests {
    @Test
    func test_standardValues() {
        #expect(ContentType.binary.stringValue == "application/octet-stream")
        #expect(ContentType.json.stringValue == "application/json")
        #expect(ContentType.plainText.stringValue == "text/plain")
    }
}
