//
//  SnackBar+Builder.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 28/07/21.
//

import Foundation

extension SnackBar {
    
    static func buildFor(type : SnackBarType , title : String,duration : Duration) -> SnackBar  {
        switch type {
        case .error:
            return Self.buildForErrorAlert(title: title, duration: duration)
        case .success :
            return Self.buildForSuccessAlert(title: title, duration: duration)
        case .warning :
            return Self.buildForWarningAlert(title: title, duration: duration)
        }
    }
    
    
    static func buildForErrorAlert(title : String , duration : Duration ) -> SnackBar {
        let snack =  SnackBar(title: title, duration: duration)
        snack.colorScheme = SnackBarType.error.colorScheme
        return snack
    }
    
    static func buildForSuccessAlert(title : String , duration : Duration ) -> SnackBar {
        let snack =  SnackBar(title: title, duration: duration)
        snack.colorScheme = SnackBarType.success.colorScheme
        return snack
    }
    
    static func buildForWarningAlert(title : String , duration : Duration ) -> SnackBar {
        let snack =  SnackBar(title: title, duration: duration)
        snack.colorScheme = SnackBarType.warning.colorScheme
        return snack
    }
}
