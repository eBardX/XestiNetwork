// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
@testable import XestiNetwork
import XestiTools

struct ParameterNameTests {
}

// MARK: -

extension ParameterNameTests {
    @Test
    func test_comparable() {
        let n1 = ParameterName("alpha")
        let n2 = ParameterName("beta")

        #expect(n1 < n2)
        #expect(!(n2 < n1))
    }

    @Test
    func test_decodeFromJSON() throws {
        let json = "\"search\""
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(ParameterName.self,
                                               from: data)

        #expect(decoded.stringValue == "search")
    }

    @Test
    func test_decodeInvalidValueThrows() throws {
        let json = "\"\""
        let data = Data(json.utf8)

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(ParameterName.self,
                                     from: data)
        }
    }

    @Test
    func test_description() {
        let name = ParameterName("query")

        #expect(name.description == "query")
    }

    @Test
    func test_encodeDecode() throws {
        let original = ParameterName("query")
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ParameterName.self,
                                               from: data)

        #expect(decoded == original)
    }

    @Test
    func test_equality() {
        let n1 = ParameterName("page")
        let n2 = ParameterName("page")

        #expect(n1 == n2)
    }

    @Test
    func test_hashable() {
        let n1 = ParameterName("page")
        let n2 = ParameterName("page")
        let n3 = ParameterName("limit")

        var set = Set<ParameterName>()

        set.insert(n1)
        set.insert(n2)
        set.insert(n3)

        #expect(set.count == 2)
    }

    @Test
    func test_inequality() {
        let n1 = ParameterName("page")
        let n2 = ParameterName("limit")

        #expect(n1 != n2)
    }

    @Test
    func test_initWithEmptyStringReturnsNil() {
        let name = ParameterName(stringValue: "")

        #expect(name == nil)
    }

    @Test
    func test_initWithValidString() {
        let name = ParameterName(stringValue: "query")

        #expect(name != nil)
        #expect(name?.stringValue == "query")
    }

    @Test
    func test_nonFailableInit() {
        let name = ParameterName("query")

        #expect(name.stringValue == "query")
    }

    @Test
    func test_stringLiteralInit() {
        let name: ParameterName = "query"

        #expect(name.stringValue == "query")
    }
}
