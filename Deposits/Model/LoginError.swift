//
//  LoginError.swift
//  Deposits
//
//  Created by Biswajit Palei on 29/07/21.
//

import Foundation
enum LoginError : Error {

    case noInternet
    case loginFailed
    
    var desciprtion : String {
        switch self {
        case .noInternet :
            return "Internet connection appears to be offline!"
        case .loginFailed :
            return "Failed to login"
        }
    }
    
}
