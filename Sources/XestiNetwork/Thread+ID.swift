//
//  Thread+ID.swift
//  XestiNetwork
//
//  Created by J. G. Pusey on 2018-11-24.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

public extension Thread {
    static var currentThreadID: UInt64 {
        var threadID: UInt64 = 0

        pthread_threadid_np(nil, &threadID)

        return threadID
    }
}
