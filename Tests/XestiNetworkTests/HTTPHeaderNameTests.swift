// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
@testable import XestiNetwork
import XestiTools

struct HTTPHeaderNameTests {
}

// MARK: -

extension HTTPHeaderNameTests {
    @Test
    func codable() throws {
        let original = HTTPHeaderName("X-Custom")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(HTTPHeaderName.self,
                                               from: data)

        #expect(decoded == original)
    }

    @Test
    func comparable() {
        let n1 = HTTPHeaderName("Accept")
        let n2 = HTTPHeaderName("Content-Type")

        #expect(n1 < n2)
        #expect(!(n2 < n1))
    }

    @Test
    func decode_fromJSON() throws {
        let json = "\"X-Custom\""
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(HTTPHeaderName.self,
                                               from: data)

        #expect(decoded.stringValue == "X-Custom")
    }

    @Test
    func decode_invalidValueThrows() throws {
        let json = "\"\""
        let data = Data(json.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(HTTPHeaderName.self,
                                     from: data)
        }
    }

    @Test
    func description() {
        let name = HTTPHeaderName("Content-Type")

        #expect(name.description == "Content-Type")
    }

    @Test
    func equality() {
        let n1 = HTTPHeaderName("Content-Type")
        let n2 = HTTPHeaderName("Content-Type")

        #expect(n1 == n2)
    }

    @Test
    func hashable() {
        let n1 = HTTPHeaderName("Accept")
        let n2 = HTTPHeaderName("Accept")
        let n3 = HTTPHeaderName("Host")

        var set = Set<HTTPHeaderName>()

        set.insert(n1)
        set.insert(n2)
        set.insert(n3)

        #expect(set.count == 2)
    }

    @Test
    func inequality() {
        let n1 = HTTPHeaderName("Content-Type")
        let n2 = HTTPHeaderName("Authorization")

        #expect(n1 != n2)
    }

    @Test
    func init_emptyStringReturnsNil() {
        let name = HTTPHeaderName(stringValue: "")

        #expect(name == nil)
    }

    @Test
    func init_nonFailable() {
        let name = HTTPHeaderName("Accept")

        #expect(name.stringValue == "Accept")
    }

    @Test
    func init_stringLiteral() {
        let name: HTTPHeaderName = "Accept"

        #expect(name.stringValue == "Accept")
    }

    @Test
    func init_validString() {
        let name = HTTPHeaderName(stringValue: "Accept")

        #expect(name != nil)
        #expect(name?.stringValue == "Accept")
    }
}
