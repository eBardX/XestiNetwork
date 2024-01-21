// © 2018–2024 John Gary Pusey (see LICENSE.md)

public enum NetworkError: Error {
    case invalidHTTPURLResponse
    case invalidURLRequest
    case missingData
    case missingLocation
    case unacceptableContentType(String)
    case unacceptableStatusCode(Int, String)
}
