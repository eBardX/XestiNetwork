// © 2018–2024 John Gary Pusey (see LICENSE.md)

import Foundation

extension Thread {
    public static var currentThreadID: UInt64 {
        var threadID: UInt64 = 0

        pthread_threadid_np(nil, &threadID)

        return threadID
    }
}
