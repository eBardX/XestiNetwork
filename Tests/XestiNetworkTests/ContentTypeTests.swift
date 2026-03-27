// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
@testable import XestiNetwork
import XestiTools

struct ContentTypeTests {
}

// MARK: -

extension ContentTypeTests {
    @Test
    func test_comparable() {
        let ct1 = ContentType("application/json")
        let ct2 = ContentType("text/plain")

        #expect(ct1 < ct2)
        #expect(!(ct2 < ct1))
    }

    @Test
    func test_decodeFromJSON() throws {
        let json = "\"application/xml\""
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(ContentType.self,
                                               from: data)

        #expect(decoded.stringValue == "application/xml")
    }

    @Test
    func test_decodeInvalidValueThrows() throws {
        let json = "\"\""
        let data = Data(json.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(ContentType.self,
                                     from: data)
        }
    }

    @Test
    func test_description() {
        let contentType = ContentType("application/json")

        #expect(contentType.description == "application/json")
    }

    @Test
    func test_encodeDecode() throws {
        let original = ContentType("application/json")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ContentType.self,
                                               from: data)

        #expect(decoded == original)
    }

    @Test
    func test_equality() {
        let ct1 = ContentType("application/json")
        let ct2 = ContentType("application/json")

        #expect(ct1 == ct2)
    }

    @Test
    func test_hashable() {
        let ct1 = ContentType("application/json")
        let ct2 = ContentType("application/json")
        let ct3 = ContentType("text/plain")

        var set = Set<ContentType>()

        set.insert(ct1)
        set.insert(ct2)
        set.insert(ct3)

        #expect(set.count == 2)
    }

    @Test
    func test_inequality() {
        let ct1 = ContentType("application/json")
        let ct2 = ContentType("text/plain")

        #expect(ct1 != ct2)
    }

    @Test
    func test_initWithEmptyStringReturnsNil() {
        let contentType = ContentType(stringValue: "")

        #expect(contentType == nil)
    }

    @Test
    func test_initWithValidString() {
        let contentType = ContentType(stringValue: "text/html")

        #expect(contentType != nil)
        #expect(contentType?.stringValue == "text/html")
    }

    @Test
    func test_nonFailableInit() {
        let contentType = ContentType("text/html")

        #expect(contentType.stringValue == "text/html")
    }

    @Test
    func test_standardValues() {
        #expect(ContentType.binary.stringValue == "application/octet-stream")
        #expect(ContentType.json.stringValue == "application/json")
        #expect(ContentType.plainText.stringValue == "text/plain")
    }

    @Test
    func test_stringLiteralInit() {
        let contentType: ContentType = "text/html"

        #expect(contentType.stringValue == "text/html")
    }
}
