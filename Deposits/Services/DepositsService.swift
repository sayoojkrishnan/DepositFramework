//
//  DepositsService.swift
//  Deposits
//
//  Created by Swathi on 14/07/21.
//

import Foundation
import Combine


protocol DepositsServiceProtocol  {
    func fetchDeposits() ->AnyPublisher<[DepositModel],DepositError>
}

final class DepositService : DepositsServiceProtocol {
    func fetchDeposits() -> AnyPublisher<[DepositModel], DepositError> {
        return Future<[DepositModel],DepositError>{ promise in
            promise(.success(MockDeposits.list))
        }
        .delay(for: 1, scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
}
