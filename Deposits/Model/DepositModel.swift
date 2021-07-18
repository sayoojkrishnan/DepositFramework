//
//  DepositModel.swift
//  Deposits
//
//  Created by Swathi on 14/07/21.
//

import UIKit.UIImage
import Foundation


struct DepositModel : Decodable  , Hashable {
    
    let id : String
    let date : String
    let amount : Double
    let description : String
    var chequeImagePath : String?
    
    
    var addedDate : Date {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        
        if let date = dateFormatterGet.date(from: date) {
            return date
        }
    
        return Date()
    }
}
