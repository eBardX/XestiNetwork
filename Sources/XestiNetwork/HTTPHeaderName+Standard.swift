// © 2018–2026 John Gary Pusey (see LICENSE.md)

private import XestiTools

extension HTTPHeaderName {
    /// Authentication credentials for HTTP authentication.
    public static let authorization = HTTPHeaderName("Authorization")

    /// The content type of the body of the HTTP request.
    public static let contentType = HTTPHeaderName("Content-Type")

    /// Identifies the user agent making the HTTP request.
    public static let userAgent = HTTPHeaderName("User-Agent")
}
