// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
@testable import XestiNetwork
import XestiTools

struct HTTPMethodTests {
}

// MARK: -

extension HTTPMethodTests {
    @Test
    func test_comparable() {
        let m1 = HTTPMethod("DELETE")
        let m2 = HTTPMethod("GET")

        #expect(m1 < m2)
        #expect(!(m2 < m1))
    }

    @Test
    func test_decodeFromJSON() throws {
        let json = "\"PATCH\""
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(HTTPMethod.self,
                                               from: data)

        #expect(decoded.stringValue == "PATCH")
    }

    @Test
    func test_decodeInvalidValueThrows() throws {
        let json = "\"\""
        let data = Data(json.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(HTTPMethod.self,
                                     from: data)
        }
    }

    @Test
    func test_description() {
        let method = HTTPMethod("GET")

        #expect(method.description == "GET")
    }

    @Test
    func test_encodeDecode() throws {
        let original = HTTPMethod("PATCH")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(HTTPMethod.self,
                                               from: data)

        #expect(decoded == original)
    }

    @Test
    func test_equality() {
        let m1 = HTTPMethod("GET")
        let m2 = HTTPMethod("GET")

        #expect(m1 == m2)
    }

    @Test
    func test_hashable() {
        let m1 = HTTPMethod("GET")
        let m2 = HTTPMethod("GET")
        let m3 = HTTPMethod("POST")

        var set = Set<HTTPMethod>()

        set.insert(m1)
        set.insert(m2)
        set.insert(m3)

        #expect(set.count == 2)
    }

    @Test
    func test_inequality() {
        let m1 = HTTPMethod("GET")
        let m2 = HTTPMethod("POST")

        #expect(m1 != m2)
    }

    @Test
    func test_initWithEmptyStringReturnsNil() {
        let method = HTTPMethod(stringValue: "")

        #expect(method == nil)
    }

    @Test
    func test_initWithValidString() {
        let method = HTTPMethod(stringValue: "GET")

        #expect(method != nil)
        #expect(method?.stringValue == "GET")
    }

    @Test
    func test_nonFailableInit() {
        let method = HTTPMethod("GET")

        #expect(method.stringValue == "GET")
    }

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

    @Test
    func test_stringLiteralInit() {
        let method: HTTPMethod = "POST"

        #expect(method.stringValue == "POST")
    }
}
