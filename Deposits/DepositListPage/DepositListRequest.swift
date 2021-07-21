//
//  DepositListRequest.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 21/07/21.
//

import Foundation

struct DepositListRequest : ServiceRequest {
    
    var path: String = "/api/data/Deposits"
    var params: [String : String]
    var method: ServiceRequestMethod = .GET
    var body: Data? = nil
    
}
