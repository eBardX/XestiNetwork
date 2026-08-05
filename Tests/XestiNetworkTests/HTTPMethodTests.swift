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
    func codable() throws {
        let original = HTTPMethod("PATCH")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(HTTPMethod.self,
                                               from: data)

        #expect(decoded == original)
    }

    @Test
    func comparable() {
        let m1 = HTTPMethod("DELETE")
        let m2 = HTTPMethod("GET")

        #expect(m1 < m2)
        #expect(!(m2 < m1))
    }

    @Test
    func decode_fromJSON() throws {
        let json = "\"PATCH\""
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(HTTPMethod.self,
                                               from: data)

        #expect(decoded.stringValue == "PATCH")
    }

    @Test
    func decode_invalidValueThrows() throws {
        let json = "\"\""
        let data = Data(json.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(HTTPMethod.self,
                                     from: data)
        }
    }

    @Test
    func description() {
        let method = HTTPMethod("GET")

        #expect(method.description == "GET")
    }

    @Test
    func equality() {
        let m1 = HTTPMethod("GET")
        let m2 = HTTPMethod("GET")

        #expect(m1 == m2)
    }

    @Test
    func hashable() {
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
    func inequality() {
        let m1 = HTTPMethod("GET")
        let m2 = HTTPMethod("POST")

        #expect(m1 != m2)
    }

    @Test
    func init_emptyStringReturnsNil() {
        let method = HTTPMethod(stringValue: "")

        #expect(method == nil)
    }

    @Test
    func init_nonFailable() {
        let method = HTTPMethod("GET")

        #expect(method.stringValue == "GET")
    }

    @Test
    func init_stringLiteral() {
        let method: HTTPMethod = "POST"

        #expect(method.stringValue == "POST")
    }

    @Test
    func init_validString() {
        let method = HTTPMethod(stringValue: "GET")

        #expect(method != nil)
        #expect(method?.stringValue == "GET")
    }
}
