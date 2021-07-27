//
//  searchResultsController.swift
//  Deposits
//
//  Created by Biswajit Palei on 27/07/21.
//

import UIKit
import Combine

class SearchResultsController: UITableViewController, UISearchResultsUpdating {
    
    // MARK: - UITableViewDataSource
    @Published var searchText : String = ""
    var cancellable : AnyCancellable?
    
    var deposits : [DepositViewModel]?
    private var searchResult : [DepositViewModel] = []
//    var searchText : String? {
//        didSet {
//            guard let dp = deposits else {
//                return
//            }
//            searchResult = dp.filter({String($0.deposit.chequeAmount ?? 0).range(of: searchText ?? "") != nil})
//            tableView.isHidden = searchResult.count == 0
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        cancellable =  $searchText.sink { searchResult in
            print("searchResult - \(searchResult)")
            print("$searchText - \(self.$searchText)")
            self.deposits = self.deposits?.filter({String($0.deposit.chequeAmount ?? 0).range(of: self.searchText) != nil})
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        print("cancellable \(String(describing: cancellable))")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepositTableViewCell", for: indexPath) as! DepositTableViewCell
        cell.depositViewModel = searchResult[indexPath.row]
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}

//UITableViewDataSource , UITableViewDelegate
extension SearchResultsController  {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let depositNib = UINib(nibName: "DepositTableViewCell", bundle: Bundle(for: DepositTableViewCell.self))
        tableView.register(depositNib, forCellReuseIdentifier: "DepositTableViewCell")
    }
}
