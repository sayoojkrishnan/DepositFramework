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
    let date : Double
    let amount : Double
    let description : String
    var checkFrontImage : String?
    var checkBackImage : String?
    
    var addedDate : Date {
        let dateLength = String(date).count
        if dateLength >= 13 {
            return Date(timeIntervalSince1970: date/1000)
        }
        return Date(timeIntervalSince1970: date)
    }
    
    
    enum  CodingKeys : String, CodingKey {
        case id = "objectId"
        case amount = "depositAmount"
        case date = "depositDate"
        case checkFrontImage = "checkFrontImage"
        case checkBackImage = "checkBackImage"
        case description = "depositDescription"
    }
}
