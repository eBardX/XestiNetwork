// © 2025–2026 John Gary Pusey (see LICENSE.md)

public import Foundation

extension Endpoint {

    // MARK: Public Nested Types

    /// Encapsulates the source of data for an HTTP upload request.
    public enum DataSource {
        /// The body data to upload.
        case bodyData(Data)

        /// The URL of the file containing the data to upload.
        case fileURL(URL)
    }
}

// MARK: - Sendable

extension Endpoint.DataSource: Sendable {
}
