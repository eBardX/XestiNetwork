// © 2018–2020 J. G. Pusey (see LICENSE.md)

import Foundation

public extension Thread {
    static var currentThreadID: UInt64 {
        var threadID: UInt64 = 0

        pthread_threadid_np(nil, &threadID)

        return threadID
    }
}
