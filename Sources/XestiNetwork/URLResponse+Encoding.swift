// © 2018–2024 John Gary Pusey (see LICENSE.md)

import Foundation

extension URLResponse {
    public var textEncoding: String.Encoding? {
        guard let name = textEncodingName
        else { return nil }

        let cfEnc = CFStringConvertIANACharSetNameToEncoding(name as CFString)

        return String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(cfEnc))
    }
}
