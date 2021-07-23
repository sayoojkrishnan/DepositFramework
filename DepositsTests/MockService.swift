//
//  MockService.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 23/07/21.
//
@testable import Deposits
import Foundation

struct MockService : ServiceRequest {
    var path: String = "/api/test"
    
    var params: [String : String]
     
    var method: ServiceRequestMethod = .GET
    
    var body: Data?
    
    var host: String {
        return "test.com"
    }
    
}
