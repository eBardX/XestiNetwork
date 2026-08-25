# XestiNetwork

A simple network abstraction layer.

## <a name="overview">Overview</a>

The XestiNetwork framework provides a simple network abstraction layer for
Swift.

Inspired by Moya, but without the nonsense (and without the cruft of
Alamofire).

An `Endpoint` describes everything needed to build and validate a single
HTTP request — its URL, method, headers, query parameters, cache policy,
timeout, and (for uploads) its data source — as well as the status codes and
content types that make a response acceptable. Extensions on `URLSession`
then let you send an endpoint directly:

```swift
let (data, response) = try await session.data(for: endpoint)
```

Endpoints are built from type-safe names rather than raw strings —
`HTTPMethod`, `HTTPHeaderName`, `ParameterName`, and `ContentType` —
so a mistyped header name or method fails to compile instead of failing at
runtime. Each of these types is open-ended: a small set of standard values
ships with the framework, and you add your own with a `static let` in an
extension.

## <a name="requirements">Requirements</a>

* iOS 16.0+ / macOS 14.0+
* Swift 6 language mode

## <a name="installation">Installation</a>

### <a name="spm_installation">Swift Package Manager</a>

XestiNetwork is distributed exclusively through the [Swift Package
Manager][spm].

To add XestiNetwork to a Swift package, add it to the `dependencies` in your
`Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/eBardX/XestiNetwork.git",
             .upToNextMajor(from: "3.2.0"))
]
```

Then add `XestiNetwork` to the dependencies of any target that uses it:

```swift
.target(name: "MyTarget",
        dependencies: [.product(name: "XestiNetwork",
                                package: "XestiNetwork")])
```

To add XestiNetwork to an Xcode project, choose **File ▸ Add Package
Dependencies…** and enter the repository URL:

```
https://github.com/eBardX/XestiNetwork.git
```

## <a name="quick_start">Quick Start</a>

Describe a request with an `Endpoint`, then send it with `URLSession`:

```swift
import Foundation
import XestiNetwork

let session = URLSession.shared

var endpoint = Endpoint(baseURL: URL(string: "https://api.example.com")!,
                        path: "/v1/status")

endpoint.headers = [.authorization: "Bearer \(token)"]
endpoint.parameters = [ParameterName("verbose")!: true]

let (data, response) = try await session.data(for: endpoint)
```

If the response's status code isn't in `acceptableStatusCodes` or its content
type isn't in `acceptableContentTypes`, the call throws a `NetworkError`
instead of handing you a response you'd have to validate yourself.

Uploading works the same way, driven by `Endpoint`'s `dataSource` property:

```swift
var upload = Endpoint(baseURL: baseURL,
                      path: "/v1/files")

upload.dataSource = .fileURL(fileURL)
upload.method = .post

let (data, response) = try await session.upload(for: upload)
```

Every piece of request construction — the URL, the header fields, the query
items, and the `URLRequest` itself — is a closure property on `Endpoint`
with a documented default. Override any of them to customize or replace that
step without giving up the rest.

## <a name="documentation">Documentation</a>

Every public declaration carries a DocC comment; `Endpoint` and the
`URLSession` extensions in particular describe their behavior in detail.

## <a name="reference_documentation">Reference Documentation</a>

Full [reference documentation][refdoc] is available courtesy of [DocC][docc].

## <a name="credits">Credits</a>

John Gary Pusey (ebardx@gmail.com)

## <a name="license">License</a>

XestiNetwork is available under [the MIT license][license].

[docc]:     https://www.swift.org/documentation/docc/
[license]:  https://github.com/eBardX/XestiNetwork/blob/main/LICENSE.md
[refdoc]:   https://eBardX.github.io/xesti-packages-docs/documentation/xestinetwork
[spm]:      https://swift.org/package-manager/
