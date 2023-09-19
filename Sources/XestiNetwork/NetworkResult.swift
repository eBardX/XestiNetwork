// © 2018–2022 J. G. Pusey (see LICENSE.md)

import Foundation

public enum NetworkResult {
    case failure(any Error)
    case success(Data, HTTPURLResponse)
}
