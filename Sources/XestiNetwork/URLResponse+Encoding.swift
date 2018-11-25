//
//  URLResponse+Encoding.swift
//  XestiNetwork
//
//  Created by J. G. Pusey on 2018-11-24.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

public extension URLResponse {
    var textEncoding: String.Encoding? {
        guard
            let name = textEncodingName
            else { return nil }

        let cfEnc = CFStringConvertIANACharSetNameToEncoding(name as CFString)

        return String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(cfEnc))
    }
}
