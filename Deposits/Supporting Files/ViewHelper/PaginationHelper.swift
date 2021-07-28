//
//  PaginationHelper.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 28/07/21.
//

import UIKit

struct PaginationHelper {
    
    static func spinner(frame : CGRect) -> UIActivityIndicatorView{
        let activity = UIActivityIndicatorView(frame: frame)
        activity.startAnimating()
        activity.color = .gray
        return activity
    }
    
    static func failedView(frame : CGRect, error :String) -> UILabel{
        let label = UILabel(frame: frame)
        label.text = error
        return label
    }
    
}
