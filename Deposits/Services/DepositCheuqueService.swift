//
//  DepositCheuqueViewModel.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 19/07/21.
//

import Combine
import Foundation

protocol DepositChequeServiceProtocol  {
    func depositCheuqe(param : [String:Any]) -> AnyPublisher<DepositModel,DepositError>
}

final class DepositChequeService : DepositChequeServiceProtocol {
    
    func depositCheuqe(param: [String : Any]) -> AnyPublisher<DepositModel, DepositError> {
        
        let service = DepositChequeRequest(params: param)
        let client = NetworkClient()
        
        return client.request(type: DepositModel.self, serviceRequest: service)
            .mapError({
                switch $0 {
                case .failedToConnectToHost :
                    return .noInternet
                default :
                    return DepositError.failedToDeposit
                }
            })
            .eraseToAnyPublisher()
    }
    
}


struct DepositChequeRequest  : ServiceRequest {
    
    var path: String = "/api/data/Deposits"
    var params: [String : String] = [:]
    var method: ServiceRequestMethod = .POST
    var body: Data?
    
    init(params : [String:Any]) {
        body = try? JSONSerialization.data(withJSONObject: params)
    }
}
