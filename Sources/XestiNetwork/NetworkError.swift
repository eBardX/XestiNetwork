//
//  NetworkError.swift
//  XestiNetwork
//
//  Created by J. G. Pusey on 2018-11-24.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

public enum NetworkError: Error {
    case invalidHTTPURLResponse
    case invalidURLRequest
    case missingData
    case missingLocation
    case unacceptableContentType(String)
    case unacceptableStatusCode(Int, String)
}
