// © 2018–2026 John Gary Pusey (see LICENSE.md)

private import XestiTools

extension ContentType {
    /// Indicates arbitrary binary data.
    public static let binary = ContentType("application/octet-stream")

    /// Indicates JavaScript Object Notation (JSON) data. 
    public static let json = ContentType("application/json")

    /// Indicates text with no markup and an unspecified encoding.
    public static let plainText = ContentType("text/plain")
}
