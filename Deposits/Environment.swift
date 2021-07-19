//
//  Environment.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 19/07/21.
//

import Foundation



enum Env {
    case prod
    case qa
    case staging
    
    var url : String {
        switch self {
        case .prod:
            return "stirredverse.backendless.app"
        case .qa :
            return "stirredverse.backendless.app"
        case .staging:
            return "stirredverse.backendless.app"
        }
    }
}

struct DepositsEnv {
    static let env : Env = .prod
}
