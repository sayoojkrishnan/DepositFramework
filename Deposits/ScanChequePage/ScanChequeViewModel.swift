//
//  ScanChequeViewModel.swift
//  DepositsFramework
//
//  Created by Sayooj Krishnan  on 16/07/21.
//

import Foundation
import UIKit.UIImage

class ScanChequeViewModel  {
    
    var chequeImage : UIImage?
    var chequeDescription : String = ""
    var date : Date = Date()
    var amount : String = ""
    
    func deposit() -> DepositModel? {
        
        guard let amount = Double(amount),!chequeDescription.isEmpty  else {return nil}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let addedDate = dateFormatter.string(from: date)
        
        //  //
      
        
        let deposit =  DepositModel(
            id: UUID().uuidString,
            date: addedDate,
            amount: amount,
            description: chequeDescription,
            chequeImagePath: nil
        )
        
        return deposit
    }
}

