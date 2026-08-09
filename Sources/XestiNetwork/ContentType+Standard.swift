// © 2018–2026 John Gary Pusey (see LICENSE.md)

private import XestiTools

extension ContentType {
    /// A content type indicating arbitrary binary data.
    public static let binary = ContentType("application/octet-stream")

    /// A content type indicating JavaScript Object Notation (JSON) data.
    public static let json = ContentType("application/json")

    /// A content type indicating text with no markup and an unspecified
    /// encoding.
    public static let plainText = ContentType("text/plain")
}
