// © 2026 John Gary Pusey (see LICENSE.md)

import Foundation
import Testing
@testable import XestiNetwork

struct EndpointDataSourceTests {
}

// MARK: -

extension EndpointDataSourceTests {
    @Test
    func bodyData() {
        let data = Data("payload".utf8)
        let dataSource = Endpoint.DataSource.bodyData(data)

        guard case let .bodyData(value) = dataSource
        else {
            Issue.record("Expected .bodyData case")
            return
        }

        #expect(value == data)
    }

    @Test
    func fileURL() throws {
        let url = try #require(URL(string: "file:///tmp/upload.dat"))
        let dataSource = Endpoint.DataSource.fileURL(url)

        guard case let .fileURL(value) = dataSource
        else {
            Issue.record("Expected .fileURL case")
            return
        }

        #expect(value == url)
    }
}
