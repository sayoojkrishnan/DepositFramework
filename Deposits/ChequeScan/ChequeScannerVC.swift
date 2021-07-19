//
//  ChequeScannerVC.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 19/07/21.
//

import UIKit

class ChequeScannerVC : UIViewController {
    
    var side : ChequImageView.ChequeSide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(primaryAction: UIAction(handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        button.setTitle("Close", for: .normal)
        
        self.view.addSubview(button)
        view.backgroundColor = .black
        
        
    }
    
    override public var shouldAutorotate: Bool {
        return false
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    
}
