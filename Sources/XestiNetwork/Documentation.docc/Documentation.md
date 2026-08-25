# ``XestiNetwork``

@Metadata {
    @PageColor(blue)
}

A simple network abstraction layer.

## Overview

The XestiNetwork framework provides a simple network abstraction layer for
Swift.

Inspired by Moya, but without the nonsense (and without the cruft of
Alamofire).

An ``Endpoint`` describes everything needed to build and validate a single
HTTP request — its URL, method, headers, query parameters, cache policy,
timeout, and (for uploads) its data source — as well as the status codes and
content types that make a response acceptable. Extensions on `URLSession`
then let you send an endpoint directly:

```swift
let (data, response) = try await session.data(for: endpoint)
```

Endpoints are built from type-safe names rather than raw strings —
``HTTPMethod``, ``HTTPHeaderName``, ``ParameterName``, and ``ContentType`` —
so a mistyped header name or method fails to compile instead of failing at
runtime. Each of these types is open-ended: a small set of standard values
ships with the framework, and you add your own with a `static let` in an
extension.

```swift
import Foundation
import XestiNetwork

var endpoint = Endpoint(baseURL: URL(string: "https://api.example.com")!,
                        path: "/v1/status")

endpoint.headers = [.authorization: "Bearer \(token)"]

let (data, response) = try await URLSession.shared.data(for: endpoint)
```

If the response's status code isn't in ``Endpoint/acceptableStatusCodes`` or
its content type isn't in ``Endpoint/acceptableContentTypes``, the call
throws a ``NetworkError`` instead of handing you a response you'd have to
validate yourself.

See ``Endpoint`` for the full details of how a request is constructed, and
the `URLSession` extension methods for how it's sent and validated.

## Topics

### Requests

- ``Endpoint``
- ``Endpoint/DataSource``

### Sending requests

- ``Foundation/URLSession/data(for:delegate:)``
- ``Foundation/URLSession/bytes(for:delegate:)``
- ``Foundation/URLSession/download(for:delegate:)``
- ``Foundation/URLSession/upload(for:delegate:)``

### Type-safe names

- ``HTTPMethod``
- ``HTTPHeaderName``
- ``ParameterName``
- ``ContentType``

### Errors

- ``NetworkError``
