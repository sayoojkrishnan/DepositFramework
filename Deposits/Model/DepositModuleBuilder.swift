//
//  DepositModuleBuilder.swift
//  DepositsFramework
//
//  Created by Sayooj Krishnan  on 16/07/21.
//

import UIKit

public struct DepositModuleBuilder  {
    
    
    public static func build() -> UINavigationController {
        let deposits = DepositListViewController.build()
        let nav =  UINavigationController(rootViewController: deposits)
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
    
    
}
