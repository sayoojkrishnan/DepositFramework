//
//  ChequeScannerVC.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 19/07/21.
//

import UIKit
import AVFoundation

protocol ChequeScannerDelegate  : AnyObject {
    func didFinishScanning(withCheque image : UIImage , side : ChequeSide)
}

class SBChequeScannerVC : UIViewController {

    var side : ChequeSide! {
        didSet {
            titleLable.text = side.description
            bottomInfoLabel.text = side.scanInstruction
        }
    }
    
    private let titleLable : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Front of cheque"
        label.font = .systemFont(ofSize: 26)
        label.textColor = .white
        return label
    }()
    
    private lazy var closeButton : UIButton = {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    
    private lazy var captureButton : UIButton = {
        
        let config = UIImage.SymbolConfiguration(scale: .large)
        let captureButton = UIButton(type: .system)
        captureButton.tintColor = .white
        captureButton.setBackgroundImage(UIImage(systemName: "largecircle.fill.circle",withConfiguration: config), for: .normal)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
        
        return captureButton
    }()
    
    
    private let bottomInfoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Front of cheque"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 17)
        label.textColor = .systemGray2
        return label
    }()
    
    weak var delegate : ChequeScannerDelegate?
    /// View representing live camera
    private lazy var cameraView: CameraView = CameraView(
        delegate: self,
        chequeFrameStrokeColor: .white,
        maskLayerColor: .black,
        maskLayerAlpha: 0.7
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutSubviews()
    }
    

    private func layoutSubviews() {
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(titleLable)
        NSLayoutConstraint.activate([
            titleLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 5)
        ])
        
        view.addSubview(bottomInfoLabel)
        NSLayoutConstraint.activate([
            bottomInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomInfoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
        
        view.addSubview(captureButton)
        NSLayoutConstraint.activate([
        
            captureButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            captureButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            captureButton.heightAnchor.constraint(equalToConstant: 60),
            captureButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        
    }

    @objc private func didTapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapRecord() {
        cameraView.capture()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AVCaptureDevice.authorize { [weak self] authoriazed in
            guard authoriazed else {
                self?.showErrorAler(message: "Permission Denied!")
                return
            }
            self?.cameraView.setupCamera()
        }
        
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.setupRegionOfInterest()
        
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
    
    private func showErrorAler(message : String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel,handler: { alert in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension SBChequeScannerVC : CameraViewDelegate {
    
    func didError(withError error: CameraViewDelegateError) {
        self.showErrorAler(message: "Failed in \(error.rawValue)")
    }
    
    
    func didCapture(image: UIImage) {
        self.dismiss(animated: true, completion: nil)
        if let side = side {
            delegate?.didFinishScanning(withCheque: image, side: side)
        }
    }
    
   
}
