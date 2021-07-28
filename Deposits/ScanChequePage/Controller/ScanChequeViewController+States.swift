//
//  ScanChequeViewController+States.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 28/07/21.
//

import UIKit
import Combine

extension ScanChequeViewController {
    func bind() {
        stateCancellable = viewModel.state
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .depositing :
                    self?.didBeginDepositing()
                case .deposited(let model) :
                    self?.didDespositSuccessfully(model: model)
                case .failed(let error ):
                    self?.didFailToDeposit(error: error)
                default :
                    break
                }
            })
    }
    
    func didBeginDepositing() {
        loadingBar.isHidden = false
        spinner.startAnimating()
    }
    
    func didDespositSuccessfully(model : DepositModel) {
        spinner.stopAnimating()
        loadingBar.isHidden = true
        delegate?.didDepositCheque(deposit: model)
        showAlert(title: "Deposited!", actionButtonText: "Close", alertType: .success) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func didFailToDeposit(error :String) {
        loadingBar.isHidden = true
        spinner.stopAnimating()
        showAlert(title: error, alertType: .error)
    }
}
