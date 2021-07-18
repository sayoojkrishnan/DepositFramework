//
//  DepositError.swift
//  Deposits
//
//  Created by Swathi on 14/07/21.
//

import Foundation
enum DepositError : Error {
    case failedToLoad
    var desciprtion : String {
        switch self {
        case .failedToLoad:
            return "Failed to retrive the deposits"
        }
    }
}
