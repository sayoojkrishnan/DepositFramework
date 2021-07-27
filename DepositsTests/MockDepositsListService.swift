//
//  MockDepositsListService.swift
//  DepositsTests
//
//  Created by Sayooj Krishnan  on 26/07/21.
//

@testable import Deposits
import Foundation
import Combine

final class MockDepositsListService : DepositsListServiceProtocol {
    
    var error : DepositError?
    var reponse : [DepositModel]?
    var hasCalledFetchDeposits :Bool = false
    func fetchDeposits(pageSize: Int, offset: Int) -> AnyPublisher<[DepositModel], DepositError> {
        hasCalledFetchDeposits = true
        return Future<[DepositModel], DepositError> {promise in
           
            if let e = self.error {
                promise(.failure(e))
                return
            }
            
            if let res = self.reponse {
                promise(.success(res))
            }

        }
        
        .eraseToAnyPublisher()
    }
    
    var mockType: MockType?
    
    
}
