//
//  CameraView.swift
//  CreditCardScannerPackageDescription
//
//  Created by josh on 2020/07/23.
//


import AVFoundation
import UIKit
import VideoToolbox

public enum CameraViewDelegateError  : String { case cameraSetup, photoProcessing, authorizationDenied, capture }
protocol CameraViewDelegate : AnyObject {
    func didCapture(image: UIImage)
    func didError(withError error: CameraViewDelegateError)
}


final class CameraView : UIView {
    
    private let heightRatioAgainstWidth: CGFloat = 0.5
    weak var delegate: CameraViewDelegate?
    private let chequeFrameStrokeColor: UIColor
    private let maskLayerColor: UIColor
    private let maskLayerAlpha: CGFloat
    
    private let photoOutput = AVCapturePhotoOutput()
    
    var cameraOrientation : AVCaptureVideoOrientation {
        if let orientation =  UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.windowScene?.interfaceOrientation {
            if orientation == .landscapeLeft {
                return .landscapeLeft
            }
        }
        return .landscapeRight
    }
    
    // MARK: - Capture related
    
    private let captureSessionQueue = DispatchQueue(
        label: "com.banking.captureSessionQueue"
    )
    
    // MARK: - Capture related
    
    //    private let sampleBufferQueue = DispatchQueue(
    //        label: "com.banking.sampleBufferQueue"
    //    )
    //
    init(
        delegate: CameraViewDelegate,
        chequeFrameStrokeColor: UIColor,
        maskLayerColor: UIColor,
        maskLayerAlpha: CGFloat
    ) {
        self.delegate = delegate
        self.chequeFrameStrokeColor = chequeFrameStrokeColor
        self.maskLayerColor = maskLayerColor
        self.maskLayerAlpha = maskLayerAlpha
        super.init(frame: .zero)
    }
    
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageRatio: ImageRatio = .vga640x480
    
    
    private var regionOfInterest: CGRect?
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        
        return layer
    }
    
    private var videoSession: AVCaptureSession? {
        get {
            videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    let semaphore = DispatchSemaphore(value: 1)
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    func stopSession() {
        self.videoSession?.stopRunning()
    }
    
    func startSession() {
        self.videoSession?.startRunning()
    }
    
    func setupCamera() {
        captureSessionQueue.async { [weak self] in
            self?._setupCamera()
        }
    }
    
    private func _setupCamera() {
        
        func errorInSetup() {
            DispatchQueue.main.async {
                self.delegate?.didError(withError: .cameraSetup)
            }
            session.commitConfiguration()
            return
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = imageRatio.preset
        
        guard let videoDevice = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back) else {
            errorInSetup()
            return
        }
        
        do {
            
            let deviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(deviceInput){
                session.addInput(deviceInput)
            }
            
        } catch {
            errorInSetup()
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        guard session.canAddOutput(videoOutput) else {
            errorInSetup()
            return
        }
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }else {
            errorInSetup()
            return
        }
        
        
        session.addOutput(videoOutput)
        session.connections.forEach {
            $0.videoOrientation = .landscapeRight
        }
        
        
        
        session.commitConfiguration()
        
        DispatchQueue.main.async { [weak self] in
            self?.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self?.videoSession = session
            self?.startSession()
            self?.videoPreviewLayer.connection?.videoOrientation = .landscapeRight
        }
        
    }
    
    
    
    func setupRegionOfInterest() {
        guard regionOfInterest == nil else { return }
        /// Mask layer that covering area around camera view
        let backLayer = CALayer()
        backLayer.frame = bounds
        backLayer.backgroundColor = maskLayerColor.withAlphaComponent(maskLayerAlpha).cgColor
        
        
        
        let cuttedWidth: CGFloat = bounds.width*0.65
        let cuttedHeight: CGFloat = cuttedWidth * heightRatioAgainstWidth
        
        let centerVertical = (bounds.height / 2.0)
        let cuttedY: CGFloat = centerVertical - (cuttedHeight / 2.0) - 10
        let cuttedX: CGFloat = bounds.width/2 - cuttedWidth/2
        
        let cuttedRect = CGRect(x: cuttedX,
                                y: cuttedY,
                                width: cuttedWidth,
                                height: cuttedHeight)
        
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: cuttedRect, cornerRadius: 10.0)
        
        path.append(UIBezierPath(rect: bounds))
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        backLayer.mask = maskLayer
        layer.addSublayer(backLayer)
        
        let strokeLayer = CAShapeLayer()
        strokeLayer.lineWidth = 3.0
        strokeLayer.strokeColor = chequeFrameStrokeColor.cgColor
        strokeLayer.path = UIBezierPath(roundedRect: cuttedRect, cornerRadius: 10.0).cgPath
        strokeLayer.fillColor = nil
        layer.addSublayer(strokeLayer)
        
        let imageHeight: CGFloat = imageRatio.imageHeight
        let imageWidth: CGFloat = imageRatio.imageWidth
        
        let acutualImageRatioAgainstVisibleSize = imageWidth / bounds.width
        let interestX = cuttedRect.origin.x * acutualImageRatioAgainstVisibleSize
        let interestWidth = cuttedRect.width * acutualImageRatioAgainstVisibleSize
        let interestHeight = interestWidth * heightRatioAgainstWidth
        let interestY = (imageHeight / 2.0) - (interestHeight / 2.0)
        regionOfInterest = CGRect(x: interestX,
                                  y: interestY,
                                  width: interestWidth,
                                  height: interestHeight)
    }
    
    func capture(){
        
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
}

extension CameraView: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        
        guard  error  == nil , let imageData = photo.fileDataRepresentation() else {
            delegate?.didError(withError: .capture)
            return
        }
        
        guard  let originalImage = UIImage(data: imageData)?.cgImage , let cropRegion = regionOfInterest else {
            delegate?.didError(withError: .photoProcessing)
            return
        }
       
        guard let croppedImage = originalImage.cropping(to: cropRegion) else {
            delegate?.didError(withError: .photoProcessing)
            return
        }
        
        let image = UIImage(cgImage: croppedImage)
        delegate?.didCapture(image: image)
    }
    
    
}



extension AVCaptureDevice {
    static func authorize(authorizedHandler: @escaping ((Bool) -> Void)) {
        let mainThreadHandler: ((Bool) -> Void) = { isAuthorized in
            DispatchQueue.main.async {
                authorizedHandler(isAuthorized)
            }
        }

        switch authorizationStatus(for: .video) {
        case .authorized:
            mainThreadHandler(true)
        case .notDetermined:
            requestAccess(for: .video, completionHandler: { granted in
                mainThreadHandler(granted)
})
        default:
            mainThreadHandler(false)
        }
    }
}
