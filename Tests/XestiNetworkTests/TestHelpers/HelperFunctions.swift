// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation

internal func makeHTTPURLResponse(url: URL,
                                  statusCode: Int = 200,
                                  contentType: String? = "application/json") -> HTTPURLResponse {
    HTTPURLResponse(url: url,
                    statusCode: statusCode,
                    httpVersion: nil,
                    headerFields: contentType.map { ["Content-Type": $0] })! // swiftlint:disable:this force_unwrapping
}
