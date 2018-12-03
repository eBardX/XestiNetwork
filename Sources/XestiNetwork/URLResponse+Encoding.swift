// © 2018 J. G. Pusey (see LICENSE.md)

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
