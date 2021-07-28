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
            .filter({$0.count > 0 })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dopsits in
                let total = self?.viewModel.totalDeposits ?? ""
                let transcation = self?.viewModel.numberOfTransaction
                self?.dataSource.updateData(deposits: dopsits)
                self?.totalTransactions.text = transcation
                self?.animateAndSetTotal(totalText: total)
                self?.depositsTableView.reloadData()
            }.store(in: &bag)
        
        
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loading :
                    self?.refreshController.beginRefreshing()
                case .failed :
                    self?.refreshController.endRefreshing()
                    let error = self?.viewModel.error ?? ""
                    self?.showFailureAlert(message: error)
                case .success :
                    self?.depositsTableView.isHidden = false
                    self?.spinner.stopAnimating()
                    self?.refreshController.endRefreshing()
                default :
                    break
                }
            }.store(in: &bag)
        
        
        dataSource.reachedEndOfScroll = { [weak self] in
            try? self?.viewModel.paginate()
        }
        
        viewModel.$paginationState
            .receive(on : DispatchQueue.main)
            .sink { [weak self ] state in
                guard let strongSelf = self else {return}
                let frame = CGRect(x: 0, y: 0, width: strongSelf.depositsTableView.frame.width, height: 50)
                switch state {
                case .failed :
                    let error = strongSelf.viewModel.error ?? ""
                    self?.depositsTableView.tableFooterView = PaginationHelper.failedView(frame: frame, error: error)
                case .success :
                    self?.depositsTableView.tableFooterView = nil
                case .loading :
                    self?.depositsTableView.tableFooterView = PaginationHelper.spinner(frame: frame)
                }
            }.store(in: &bag)
        
        
        viewModel.$refreshDepositsListResult
            .receive(on: DispatchQueue.main)
            .compactMap{$0}
            .sink { [weak self] state in
                if state == .noNewItem {
                    self?.showAlert(title: state.message, alertType: .warning)
                }else if state == .refreshed {
                    self?.showAlert(title: state.message, alertType: .success)
                }
            }.store(in: &bag)
    }
   
}
