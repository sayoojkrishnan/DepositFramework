//
//  DepositListViewController.swift
//  DepositsFramework
//
//  Created by Sayooj Krishnan  on 16/07/21.
//

import UIKit
import Combine

class DepositListViewController: BaseViewController {
    
    class func build() -> DepositListViewController {
        return DepositListViewController(nibName: "DepositListViewController", bundle: Bundle(for: DepositListViewController.self))
    }
    
    private(set) lazy var searchController: UISearchController = {
        resultsTableController = SearchResultsController()
        let searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Deposit"
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        searchController.searchResultsUpdater = resultsTableController
        return searchController
    }()
    
    private(set) var refreshController : UIRefreshControl!
    private(set) var dataSource =  DepositListTableViewDataSource()
    @IBOutlet weak var depositsTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var bag = Set<AnyCancellable>()
    private(set) var viewModel = DepositsListViewModel()
    private(set) var resultsTableController: SearchResultsController!
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Deposits"
        configureRefreshControll()
        configureTableView()
        buildNabutton()
        bind()
        viewModel.fetchDeposits()
        spinner.startAnimating()
    }
    
    
    func showFailureAlert(message :String) {
        showAlert(title: message, actionButtonText: "Retry",alertType: .error ) { [unowned self] in
            self.viewModel.fetchDeposits()
        }
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
        refreshController = UIRefreshControl(frame: CGRect.zero, primaryAction: UIAction(handler: { [unowned self ]action in
            self.paginate()
        }))
        depositsTableView.refreshControl = refreshController
    }
    
    func paginate() {
        do {
            try self.viewModel.paginate()
        }catch {
            self.refreshController.endRefreshing()
            showAlert(title: "No more data available", alertType: .warning)
        }
    }
}

extension DepositListViewController : ScanChequeResponseDelegate {
    func didDepositCheque(deposit: DepositModel) {
        viewModel.deposit(deposit: deposit)
    }
}
