// © 2025 John Gary Pusey (see LICENSE.md)

import Foundation

extension Endpoint {

    // MARK: Public Nested Types

    public enum DataSource {
        case bodyData(Data)
        case fileURL(URL)
    }
}

// MARK: - Sendable

extension Endpoint.DataSource: Sendable {
}
