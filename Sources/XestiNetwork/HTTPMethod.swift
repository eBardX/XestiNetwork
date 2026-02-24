// © 2018–2026 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct HTTPMethod: StringRepresentable {

    // MARK: Public Initializers

    public init(_ stringValue: String) {
        self.stringValue = Self.requireValid(stringValue)
    }

    // MARK: Public Instance Properties

    public let stringValue: String
}
