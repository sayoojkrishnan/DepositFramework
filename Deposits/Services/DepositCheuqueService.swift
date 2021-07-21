//
//  DepositCheuqueViewModel.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 19/07/21.
//

import Combine
import Foundation

protocol DepositChequeServiceProtocol  : MockNeworkServiceBuildable {
    func depositCheuqe(param : [String:Any]) -> AnyPublisher<DepositModel,DepositError>
}

final class DepositChequeService : DepositChequeServiceProtocol {
    
    
    var mockType: MockType?
    
    func depositCheuqe(param: [String : Any]) -> AnyPublisher<DepositModel, DepositError> {
        
        let service = DepositChequeRequest(params: param)
        mockType = .mockData(buildDummyResponseData(param: param))
        
        let client = client
        
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
    
    
    private func buildDummyResponseData(param : [String:Any]) -> Data{
        
        let newResponse = DepositModel(
            id: UUID().uuidString,
            date: param["depositDate"] as? Double,
            chequeAmount: param["depositAmount"]  as? Double,
            description: param["depositDescription"]  as? String,
            checkFrontImage: nil,
            checkBackImage: nil
        )
        
        return try! JSONEncoder().encode(newResponse)
    }
    
}
