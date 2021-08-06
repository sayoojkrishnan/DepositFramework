//
//  ScanChequeViewController+Delgates.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 28/07/21.
//

import UIKit

extension ScanChequeViewController : ChequImageViewDelegate {
    
    func didRequestToOpenCamera(for chequeSide: ChequeSide) {
        let scanner = SBChequeScannerVC()
        scanner.side = chequeSide
        scanner.delegate = self
        scanner.modalPresentationStyle = .fullScreen
        self.present(scanner, animated: true, completion: nil)
    }
    
}

extension ScanChequeViewController : ChequeScannerDelegate {
    
    func didFinishScanning(withCheque image: UIImage, side: ChequeSide) {
        
        if side == .back {
            self.viewModel.chequeBackImage  = image
        }else {
            self.viewModel.chequeFrontImage = image
        }
        
        self.chequeFrontImage.chequeImage = self.viewModel.chequeFrontImage
        self.chequeBackImage.chequeImage =  self.viewModel.chequeBackImage
    }
    
}
