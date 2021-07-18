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
    
    @IBOutlet weak var depositsTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var bag = Set<AnyCancellable>()
    private var viewModel = DepositsListViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Deposits"
        
        configureTableView()
        viewModel.fetchDeposits()
        bind()
        buildNabutton()
        
    }
    
    
    private func bind() {
        
        viewModel.$deposits
            .receive(on: RunLoop.main)
            .sink { [weak self]_ in
                self?.depositsTableView.reloadData()
            }.store(in: &bag)
        
        
        viewModel.$viewState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                switch state {
                case .loading :
                    self?.spinner.startAnimating()
                case .failed(let error) :
                    self?.spinner.stopAnimating()
                    self?.showFailureAlert(message: error)
                case .success :
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
}

extension DepositListViewController : ScanChequeResponseDelegate {
    func didDepositCheque(deposit: DepositModel) {
        viewModel.deposit(deposit: deposit)
    }
}

extension DepositListViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    private func configureTableView() {
        depositsTableView.delegate = self
        depositsTableView.dataSource = self
        depositsTableView.isHidden = true
        
        let depositNib = UINib(nibName: "DepositTableViewCell", bundle: Bundle(for: DepositTableViewCell.self))
        depositsTableView.register(depositNib, forCellReuseIdentifier: "DepositTableViewCell")
        let totalNib = UINib(nibName: "DepositsTotalCell", bundle: Bundle(for: DepositsTotalCell.self))
        depositsTableView.register(totalNib, forCellReuseIdentifier: "DepositsTotalCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sectionHeaderTitle(for: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DepositsTotalCell", for: indexPath) as! DepositsTotalCell
            cell.totalDeposits.text = viewModel.totalDeposits
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DepositTableViewCell", for: indexPath) as! DepositTableViewCell
            cell.depositViewModel = viewModel.depositViewModelFor(indexPath: indexPath)
            return cell
        }
        
    }
    
}



