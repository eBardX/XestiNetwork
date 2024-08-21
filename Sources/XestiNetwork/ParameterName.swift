// © 2018–2024 John Gary Pusey (see LICENSE.md)

import XestiTools

public struct ParameterName: StringRepresentable {

    // MARK: Public Initializers

    public init(_ stringValue: String) {
        precondition(Self.isValid(stringValue),
                     Self.invalidMessage)

        self.stringValue = stringValue
    }

    // MARK: Public Instance Properties

    public let stringValue: String
}
