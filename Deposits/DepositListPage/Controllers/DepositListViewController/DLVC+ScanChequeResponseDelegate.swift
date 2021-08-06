//
//   DepositListViewController+ScanChequeResponseDelegate.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 28/07/21.
//

import Foundation

extension DepositListViewController : ScanChequeResponseDelegate {
    func didDepositCheque(deposit: DepositModel) {
        viewModel.deposit(deposit: deposit)
    }
}
