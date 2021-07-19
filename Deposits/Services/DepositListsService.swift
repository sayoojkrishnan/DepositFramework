//
//  DepositsService.swift
//  Deposits
//
//  Created by Swathi on 14/07/21.
//

import Foundation
import Combine


protocol DepositsListServiceProtocol  {
    func fetchDeposits(page : String) ->AnyPublisher<[DepositModel],DepositError>
}

final class DepositListsService : DepositsListServiceProtocol {
    
    func fetchDeposits(page : String = "100") -> AnyPublisher<[DepositModel], DepositError> {
        
        let request = DepositListRequest(params: ["pageSize" : page])
        let client = NetworkClient()
        return client
            .request(type: [DepositModel].self, serviceRequest: request)
            .mapError({ error in
                switch error {
                case .failedToConnectToHost :
                    return .noInternet
                default :
                    return DepositError.failedToLoad
                }
            })
            .eraseToAnyPublisher()
    }
    
}


struct DepositListRequest : ServiceRequest {
    
    var path: String = "/api/data/Deposits"
    var params: [String : String]
    var method: ServiceRequestMethod = .GET
    var body: Data? = nil

}
