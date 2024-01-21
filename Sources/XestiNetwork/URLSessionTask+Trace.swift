// © 2018–2024 John Gary Pusey (see LICENSE.md)

import Foundation

extension URLSessionTask {

    // MARK: Public Instance Methods

    public func trace(with writer: (String) -> Void,
                      prefix: String = "📤  ",
                      includeThreadID: Bool = true,
                      includeHeaders: Bool = true) {
        guard let request = originalRequest,
              let method = request.httpMethod,
              let urlString = request.url?.absoluteString
        else { return }

        var traceText = prefix

        traceText.append("[")

        if includeThreadID {
            traceText.append(String(Thread.currentThreadID))
            traceText.append(":")
        }

        traceText.append(String(taskIdentifier))
        traceText.append("] ")
        traceText.append(method)
        traceText.append(" ")
        traceText.append(urlString)

        var headerIncluded = false

        if includeHeaders {
            for field in request.allHTTPHeaderFields ?? [:] {
                traceText.append("\n")
                traceText.append(field.key)
                traceText.append(": ")
                traceText.append(field.value)

                headerIncluded = true
            }
        }

        if method == HTTPMethod.post.stringValue,
           let bodyData = request.httpBody,
           !bodyData.isEmpty,
           let bodyString = String(data: bodyData,
                                   encoding: .utf8) {
            traceText.append(headerIncluded ? "\n\n" : "\n")
            traceText.append(bodyString)
        }

        writer(traceText)
    }

    public func trace(with writer: (String) -> Void,
                      result: NetworkResult,
                      prefix: String = "📥  ",
                      includeThreadID: Bool = true,
                      includeHeaders: Bool = true) {
        var traceText = prefix

        switch result {
        case let .failure(error):
            traceText.append("[")

            if includeThreadID {
                traceText.append(String(Thread.currentThreadID))
                traceText.append(":")
            }

            traceText.append(String(taskIdentifier))
            traceText.append("] Response data (0 bytes), ")

            let error = error as NSError

            traceText.append("error ")
            traceText.append(error.domain)
            traceText.append(String(error.code))
            traceText.append(": ")
            traceText.append(error.localizedDescription)

        case let .success(data, response):
            traceText.append("[")

            if includeThreadID {
                traceText.append(String(Thread.currentThreadID))
                traceText.append(":")
            }

            traceText.append(String(taskIdentifier))
            traceText.append("] Response data (")
            traceText.append(String(data.count))
            traceText.append(" bytes):")

            var headerIncluded = false

            if includeHeaders {
                for field in response.allHeaderFields {
                    traceText.append("\n")
                    traceText.append(String(describing: field.key))
                    traceText.append(": ")
                    traceText.append(String(describing: field.value))

                    headerIncluded = true
                }
            }

            if !data.isEmpty,
               let dataString = String(data: data,
                                       encoding: response.textEncoding ?? .utf8) {
                traceText.append(headerIncluded ? "\n\n" : "\n")
                traceText.append(dataString)
            }
        }

        writer(traceText)
    }
}
