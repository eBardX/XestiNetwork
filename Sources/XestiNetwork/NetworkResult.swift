// © 2018–2024 John Gary Pusey (see LICENSE.md)

import Foundation

public enum NetworkResult {
    case failure(any Error)
    case success(Data, HTTPURLResponse)
}
