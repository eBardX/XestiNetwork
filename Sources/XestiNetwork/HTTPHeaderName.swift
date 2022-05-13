// © 2018–2022 J. G. Pusey (see LICENSE.md)

public struct HTTPHeaderName: Equatable, Hashable, RawRepresentable {

    // MARK: Public Initializers

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: Public Instance Properties

    public var rawValue: String
}

// MARK: - CustomStringConvertible

extension HTTPHeaderName: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}
