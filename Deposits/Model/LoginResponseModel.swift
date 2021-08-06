//
//  LoginResponseModel.swift
//  Deposits
//
//  Created by Biswajit Palei on 29/07/21.
//

import Foundation


struct LoginResponseModel: Codable, Hashable {
    let firstName:String
    let lastName:String
    let email:String
}
