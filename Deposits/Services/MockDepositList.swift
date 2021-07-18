//
//  DummyDepositBuilder.swift
//  Deposits
//
//  Created by Swathi on 14/07/21.
//

import Foundation

struct MockDeposits {
    static var list : [DepositModel ] {
        
        
        let d1 = DepositModel(
            id: "1",
            date: "10-07-2021",
            amount: 100.0,
            description: "Deposit 1",
            chequeImagePath: "path"
        )
        let d2 = DepositModel(
            id: "2",
            date: "11-07-2021",
            amount: 20.0,
            description: "Deposit 2",
            chequeImagePath: "path2"
        )
        let d3 = DepositModel(
            id: "3", date: "11-07-2021",
            amount: 2000,
            description: "Deposit 3",
            chequeImagePath: "path"
        )
        let d4 = DepositModel(
            id: "4",
            date: "11-07-2021",
            amount: 50,
            description: "Deposit 4",
            chequeImagePath: "path"
        )
        let d5 = DepositModel(
            id: "5",
            date: "13-07-2021",
            amount: 1000.0,
            description: "Deposit 5",
            chequeImagePath: "path"
        )
        let d6 = DepositModel(
            id: "6",
            date: "13-07-2021",
            amount: 900,
            description: "Deposit 6",
            chequeImagePath: "path"
        )
        let d7 = DepositModel(
            id: "7",
            date: "13-07-2021",
            amount: 5300,
            description: "Deposit 7",
            chequeImagePath: "path"
        )
        let d8 = DepositModel(
            id: "8",
            date: "14-07-2021",
            amount: 100.0,
            description: "Deposit 8",
            chequeImagePath: "path"
        )
        let d9 = DepositModel(
            id: "9",
            date: "14-07-2021",
            amount: 2500.0,
            description: "Deposit 9",
            chequeImagePath: "path"
        )
        
        return [d1,d2,d3,d4,d5,d6,d7,d8,d9]
    }
    
}
