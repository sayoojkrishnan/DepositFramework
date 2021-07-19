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
        return dateFormatterGet.string(from: deposit.addedDate)
        
    }
    
    var amount : String {
        return "$" + String(format: "%.2f", deposit.amount)
    }
    
    var description : String {
        deposit.description
    }
    
    var chequeFrontImage : URL? {
        if let path = deposit.checkFrontImage {
            return URL(string: path)
        }
        return nil
    }
    var chequeBackImage : URL? {
        if let path = deposit.checkBackImage {
            return URL(string: path)
        }
        return nil
    }
    
    var addedDate : Date {
        return deposit.addedDate
    }
    
}
