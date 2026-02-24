// © 2018–2026 John Gary Pusey (see LICENSE.md)

import XestiTools

/// A type-safe HTTP header field name.
public struct HTTPHeaderName: StringRepresentable {

    // MARK: Public Initializers

    /// Creates a new HTTP header field name instance with the provided string
    /// value.
    ///
    /// If the provided string value is empty, this initializer stops program
    /// execution.
    ///
    /// - Parameter stringValue:	The string value to use for the new HTTP
    /// 							header field name instance.
    public init(_ stringValue: String) {
        self.stringValue = Self.requireValid(stringValue)
    }

    // MARK: Public Instance Properties

    /// The string value that represents this type.
    ///
    /// A new HTTP header field name instance initialized with `stringValue`
    /// will be equivalent to this instance.
    public let stringValue: String
}
