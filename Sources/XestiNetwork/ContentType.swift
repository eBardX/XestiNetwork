// © 2018–2026 John Gary Pusey (see LICENSE.md)

public import XestiTools

/// A type-safe content type for matching against a Content-Type header field.
public struct ContentType: StringRepresentable {

    // MARK: Public Initializers

    /// Creates a new content type instance with the provided string value.
    ///
    /// If the provided string value is empty, this initializer returns `nil`.
    ///
    /// - Parameter stringValue:    The string value to use for the new content
    ///                             type instance.
    public init?(stringValue: String) {
        guard Self.isValid(stringValue)
        else { return nil }

        self.stringValue = stringValue
    }

    // MARK: Public Instance Properties

    /// The string value that represents this type.
    ///
    /// A new content type instance initialized with `stringValue` will be
    /// equivalent to this instance.
    public let stringValue: String
}
