//
//  DepositChequeRequest.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 21/07/21.
//

import Foundation


struct DepositChequeRequest  : ServiceRequest {
    
    var path: String = "/api/data/Deposits"
    var params: [String : String] = [:]
    var method: ServiceRequestMethod = .POST
    var body: Data?
    
    init(params : [String:Any]) {
        body = try? JSONSerialization.data(withJSONObject: params)
    }
}
