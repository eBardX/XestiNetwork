// © 2018–2026 John Gary Pusey (see LICENSE.md)

import XestiTools

/// A type-safe HTTP request method.
public struct HTTPMethod: StringRepresentable {

    // MARK: Public Initializers

    /// Creates a new HTTP request method instance with the provided string
    /// value.
    ///
    /// If the provided string value is empty, this initializer stops program
    /// execution.
    ///
    /// - Parameter stringValue:    The string value to use for the new HTTP
    ///                             request method instance.
    public init(_ stringValue: String) {
        self.stringValue = Self.requireValid(stringValue)
    }

    // MARK: Public Instance Properties

    /// The string value that represents this type.
    ///
    /// A new HTTP request method instance initialized with `stringValue` will
    /// be equivalent to this instance.
    public let stringValue: String
}
