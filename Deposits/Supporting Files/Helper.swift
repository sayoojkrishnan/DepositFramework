//
//  Helpers.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 27/07/21.
//

import Foundation

class Helper {
    
    static var bundleID : String? {
        let bundle = Bundle(for: self)
        return bundle.bundleIdentifier
    }
}
struct LoginConstant {
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let passwordMinLength = 8
    static let passwordMaxLength = 16
    
}
