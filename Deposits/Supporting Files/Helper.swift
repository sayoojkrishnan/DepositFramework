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
