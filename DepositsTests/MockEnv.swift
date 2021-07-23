//
//  MockEnv.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 23/07/21.
//

@testable import Deposits

import Foundation


struct MockEnv : EnvBuildable {
    var shouldMock: Bool {
        return true
    }
    
    var env: Env = .mock
}
