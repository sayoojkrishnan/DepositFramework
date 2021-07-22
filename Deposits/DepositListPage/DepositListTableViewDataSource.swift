//
//  DepositListTableViewDataSource.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 22/07/21.
//

import UIKit

class DepositListTableViewDataSource : NSObject, UITableViewDelegate, UITableViewDataSource {
    
    
    var deposits : [DepositViewModel]?
    var total : String?
    var transcationCount : String?
    
    
    enum Sections  : Int{
        case total = 0
        case deposits = 1
        
        static func sectionHeader(for section : Int) ->String {
            if section == 0 {
                return "Total"
            }
            return "Deposits"
        }
        
    }
  
    var numberOfSections : Int {
        return 2
    }
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Sections.sectionHeader(for: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return deposits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DepositsTotalCell", for: indexPath) as! DepositsTotalCell
            cell.totalDeposits.text = total
            cell.numberOfTransactions.text = transcationCount
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DepositTableViewCell", for: indexPath) as! DepositTableViewCell
            if let deposit = deposits?[indexPath.row] {
                cell.depositViewModel = deposit
            }
            return cell
        }
        
    }
    
    
    func updateData(deposits : [DepositViewModel]? , total : String?, transcations : String?) {
        self.deposits = deposits
        self.transcationCount = transcations
        self.total = total
    }
}
