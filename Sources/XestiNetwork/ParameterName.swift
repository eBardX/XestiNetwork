//
//  ParameterName.swift
//  XestiNetwork
//
//  Created by J. G. Pusey on 2018-11-24.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

public struct ParameterName: Equatable, Hashable, RawRepresentable {

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

extension ParameterName: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}
