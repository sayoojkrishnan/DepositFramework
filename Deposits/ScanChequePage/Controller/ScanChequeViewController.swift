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

class ScanChequeViewController: UIViewController {
    
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
    
    private func bind() {
        stateCancellable = viewModel.state
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .depositing :
                    self?.loadingBar.isHidden = false
                    self?.spinner.startAnimating()
                case .deposited(let model) :
                    self?.spinner.stopAnimating()
                    self?.loadingBar.isHidden = true
                    self?.delegate?.didDepositCheque(deposit: model)
                    self?.showAlert(title: "Deposited")
                case .failed(let error ):
                    self?.loadingBar.isHidden = true
                    self?.spinner.stopAnimating()
                    self?.showAlert(title: error,hasFailedToDeposit: true)
                default :
                    break
                }
            })
    }
    
    
    @objc private func didTapOnView() {
        self.view.endEditing(true)
    }
    
    private func buildNabutton() {
        let barbutton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        navigationItem.rightBarButtonItem = barbutton
    }
    
    @objc private func didTapSave() {
        viewModel.amount = amount.text!
        viewModel.chequeDescription = chequeDescription.text!
        viewModel.date = date.date
        viewModel.deposit()
    }
    
    
    func showAlert(title : String , hasFailedToDeposit : Bool = false ) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { clicked in
            if !hasFailedToDeposit {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
}


extension ScanChequeViewController : ChequImageViewDelegate {
    
    func didRequestToOpenCamera(for chequeSide: ChequImageView.ChequeSide) {
        let scanner = ChequeScannerVC()
        scanner.side = chequeSide
        scanner.modalPresentationStyle = .fullScreen
        self.present(scanner, animated: true, completion: nil)
    }
    
}
