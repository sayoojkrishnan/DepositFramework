//
//  ScanChequeViewController.swift
//  DepositsFramework
//
//  Created by Sayooj Krishnan  on 16/07/21.
//

import UIKit
import  Combine

protocol ScanChequeResponseDelegate : AnyObject {
    func didDepositCheque(deposit : DepositModel)
}

class ScanChequeViewController: BaseViewController {
    
    @IBOutlet weak var loadingBar: UIStackView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var chequeBackImage: ChequImageView!
    @IBOutlet weak var chequeFrontImage: ChequImageView!
    @IBOutlet weak var chequeDescription : UITextField!
    @IBOutlet weak var date: UIDatePicker!
    
    weak var delegate : ScanChequeResponseDelegate?
    var viewModel : ScanChequeViewModel = ScanChequeViewModel()
    
    var stateCancellable : AnyCancellable?
    
    class func build() -> ScanChequeViewController {
        return ScanChequeViewController(nibName: "ScanChequeViewController", bundle: Bundle(for: ScanChequeViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New deposit"
        buildNabutton()
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapSave)))
        loadingBar.isHidden = true
        spinner.hidesWhenStopped = true
        bind()
        
        chequeBackImage.chequeSide = .back
        chequeBackImage.delegate = self
        
        chequeFrontImage.chequeSide = .front
        chequeFrontImage.delegate = self
    }
    
   
    
    private func buildNabutton() {
        let barbutton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        navigationItem.rightBarButtonItem = barbutton
    }
    
    @objc private func didTapSave() {
        self.view.endEditing(true)
        viewModel.amount = amount.text!
        viewModel.chequeDescription = chequeDescription.text!
        viewModel.date = date.date
        viewModel.deposit()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    
}

