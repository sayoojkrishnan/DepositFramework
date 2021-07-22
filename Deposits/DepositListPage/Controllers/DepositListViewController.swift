//
//  DepositListViewController.swift
//  DepositsFramework
//
//  Created by Sayooj Krishnan  on 16/07/21.
//

import UIKit
import Combine

class DepositListViewController: UIViewController {
    
    class func build() -> DepositListViewController {
        return DepositListViewController(nibName: "DepositListViewController", bundle: Bundle(for: DepositListViewController.self))
    }
    
    private var refreshController : UIRefreshControl!
    private var dataSource =  DepositListTableViewDataSource()
    @IBOutlet weak var depositsTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var bag = Set<AnyCancellable>()
    private var viewModel = DepositsListViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Deposits"
        configureRefreshControll()
        configureTableView()
        viewModel.fetchDeposits()
        bind()
        buildNabutton()
        
    }
    
    
    private func bind() {
        
        
        viewModel.$deposits
            .receive(on: RunLoop.main)
            .sink { [weak self] dopsits in
                let total = self?.viewModel.totalDeposits
                let transcation = self?.viewModel.numberOfTransaction
                self?.dataSource.updateData(deposits: dopsits, total: total, transcations: transcation)
                self?.depositsTableView.reloadData()
            }.store(in: &bag)
        
        
        viewModel.$viewState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                switch state {
                case .loading :
                    self?.spinner.startAnimating()
                case .failed(let error) :
                    self?.refreshController.endRefreshing()
                    self?.spinner.stopAnimating()
                    self?.showFailureAlert(message: error)
                case .success :
                    self?.refreshController.endRefreshing()
                    self?.spinner.stopAnimating()
                    self?.depositsTableView.isHidden = false
                default :
                    break
                }
            }.store(in: &bag)
    }
    
    
    
    private func showFailureAlert(message :String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.viewModel.fetchDeposits()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func buildNabutton() {
        let barbutton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapDeposit))
        navigationItem.rightBarButtonItem = barbutton
    }
    
    
    @objc private func didTapDeposit() {
        let scan = ScanChequeViewController.build()
        scan.delegate = self
        navigationController?.pushViewController(scan, animated: true)
    }
    
    private func configureRefreshControll() {
        refreshController = UIRefreshControl(frame: CGRect.zero, primaryAction: UIAction(handler: { action in
            self.refreshController.beginRefreshing()
            self.viewModel.fetchDeposits()
        }))
        depositsTableView.refreshControl = refreshController
    }
}

extension DepositListViewController : ScanChequeResponseDelegate {
    func didDepositCheque(deposit: DepositModel) {
        viewModel.deposit(deposit: deposit)
    }
}

//UITableViewDataSource , UITableViewDelegate
extension DepositListViewController  {
    
    
    private func configureTableView() {
        depositsTableView.delegate = dataSource
        depositsTableView.dataSource = dataSource
        depositsTableView.isHidden = true
        
        let depositNib = UINib(nibName: "DepositTableViewCell", bundle: Bundle(for: DepositTableViewCell.self))
        depositsTableView.register(depositNib, forCellReuseIdentifier: "DepositTableViewCell")
        let totalNib = UINib(nibName: "DepositsTotalCell", bundle: Bundle(for: DepositsTotalCell.self))
        depositsTableView.register(totalNib, forCellReuseIdentifier: "DepositsTotalCell")
    }
    

}


