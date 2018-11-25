//
//  HTTPTask.swift
//  XestiNetwork
//
//  Created by J. G. Pusey on 2018-11-24.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

public enum HTTPTask {
    case data
    case downloadData
    case downloadFile(URL)
    case uploadData(Data)
    case uploadFile(URL)
}
