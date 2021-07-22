//
//  DepositsService.swift
//  Deposits
//
//  Created by Swathi on 14/07/21.
//

import Foundation
import Combine


protocol DepositsListServiceProtocol : MockNeworkServiceBuildable  {
    func fetchDeposits(page : String) ->AnyPublisher<[DepositModel],DepositError>
}

final class DepositListsService : DepositsListServiceProtocol {
    
    var mockType: MockType? = .localJSON("deposits_list")
    
    func fetchDeposits(page : String = "100") -> AnyPublisher<[DepositModel], DepositError> {
        
        let request = DepositListRequest(params: ["pageSize" : page])
        let client = client
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
