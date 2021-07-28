//
//  DepositListViewController+UIBindings.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 28/07/21.
//

import UIKit
import Combine
extension DepositListViewController {
    func bind() {
       
       viewModel.$deposits
           .receive(on: DispatchQueue.main)
           .sink { [weak self] dopsits in
               let total = self?.viewModel.totalDeposits
               let transcation = self?.viewModel.numberOfTransaction
               self?.dataSource.updateData(deposits: dopsits, total: total, transcations: transcation)
               self?.depositsTableView.reloadData()
           }.store(in: &bag)
       
       
       viewModel.$viewState
           .receive(on: DispatchQueue.main)
           .sink { [weak self] state in
               switch state {
               case .loading :
                   self?.refreshController.beginRefreshing()
               case .failed(let error) :
                   self?.refreshController.endRefreshing()
                   self?.showFailureAlert(message: error)
               case .success :
                   self?.depositsTableView.isHidden = false
                   self?.spinner.stopAnimating()
                   self?.refreshController.endRefreshing()
               default :
                   break
               }
           }.store(in: &bag)
   }
}
