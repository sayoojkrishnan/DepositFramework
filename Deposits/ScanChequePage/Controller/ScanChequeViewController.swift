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
    
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var scanImageView: UIImageView!
    @IBOutlet weak var chequeDescription : UITextField!
    @IBOutlet weak var date: UIDatePicker!
    
    weak var delegate : ScanChequeResponseDelegate?
  
    var viewModel : ScanChequeViewModel = ScanChequeViewModel()
    
    class func build() -> ScanChequeViewController {
        return ScanChequeViewController(nibName: "ScanChequeViewController", bundle: Bundle(for: ScanChequeViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildNabutton()
        view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(didTapSave)))
    }
    
    @objc private func didTapOnView() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func didTapScan(_ sender: UIButton) {

        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = false
            self.present(picker, animated: true)
        }
    }
    
}

extension ScanChequeViewController  :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        scanImageView.image = originalImage
        //for image rotation
        viewModel.chequeImage = originalImage
    }
    
    
    private func buildNabutton() {
        let barbutton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        navigationItem.rightBarButtonItem = barbutton
    }
    
    @objc private func didTapSave() {
        viewModel.amount = amount.text!
        viewModel.chequeDescription = chequeDescription.text!
        viewModel.date = date.date
        if let depositedModel = viewModel.deposit() {
            delegate?.didDepositCheque(deposit: depositedModel)
            showAlert(title: "Deposited")
        }else {
            showAlert(title: "Failed to deposit", hasFailedToDeposit: true)
        }
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
