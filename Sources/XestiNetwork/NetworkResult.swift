//
//  NetworkResult.swift
//  XestiNetwork
//
//  Created by J. G. Pusey on 2018-11-24.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

public enum NetworkResult {
    case failure(Error)
    case success(Data, HTTPURLResponse)
}
