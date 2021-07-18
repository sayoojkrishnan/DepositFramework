//
//  DepositViewModel.swift
//  BankingApp
//
//  Created by Sayooj Krishnan  on 15/07/21.
//

import Foundation

struct DepositViewModel  : Identifiable {
    
    var id : String {
        deposit.id
    }
    
    let deposit : DepositModel
    
    var date : String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: deposit.date) {
            return dateFormatterPrint.string(from: date)
        }
        return "-"
    }
    
    var amount : String {
        return "$\(deposit.amount)"
    }
    
    var description : String {
        deposit.description
    }
    
    var chequePath : URL? {
        if let path = deposit.chequeImagePath {
            return URL(string: path)
        }
        return nil
    }
    
    var addedDate : Date {
        return deposit.addedDate
    }
    
}
