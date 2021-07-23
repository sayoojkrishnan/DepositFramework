//
//  MockNeworkService.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 23/07/21.
//
@testable import Deposits
import Foundation

struct MockNeworkService : MockNeworkServiceBuildable {
    
    var mockType: MockType?
    
    var env: EnvBuildable {
        return MockEnv()
    }
}
