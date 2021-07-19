//
//  ChequImageView.swift
//  Deposits
//
//  Created by Sayooj Krishnan  on 18/07/21.
//

import UIKit

class ChequImageView : UIView {
    
    enum ChequeSide   {
        case front
        case back
        
        var description :String {
            switch  self {
            case .front:
                return "Front of cheque"
            case .back :
                return "Back of cheque"
            }
        }
    }
    
    var chequeSide : ChequeSide? {
        didSet {
            chequePostionLabel.text = chequeSide?.description
        }
    }
    
    private var dummyImage  : UIImage {
        let sizeConf = UIImage.SymbolConfiguration(pointSize: 340)
        return UIImage(systemName: "camera",withConfiguration: sizeConf)!
    }
    
    var chequeImage : UIImage? {
        didSet {
            guard let image = chequeImage else {
                chequeImageView.image = dummyImage
                return
            }
            chequeImageView.image = image
        }
    }
    
    
    let chequeImageView : UIImageView = {
        let chequeImageView =  UIImageView()
        chequeImageView.translatesAutoresizingMaskIntoConstraints = false
        chequeImageView.contentMode = .scaleAspectFit
        chequeImageView.tintColor = .systemGray3
        return chequeImageView
    }()
    
    let chequePostionLabel : UILabel = {
        let chequePostionLabel = UILabel()
        chequePostionLabel.translatesAutoresizingMaskIntoConstraints = false
        chequePostionLabel.text = "Front of the cheque"
        chequePostionLabel.font = .systemFont(ofSize: 14)
        chequePostionLabel.textColor = .systemGray2
        chequePostionLabel.textAlignment = .center
        return chequePostionLabel
    }()
    
    
    @objc private func didTapToView(tap : UITapGestureRecognizer) {
        
        // Show 
    }
    
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = .tertiarySystemGroupedBackground
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToView(tap:))))
        chequeImageView.image = dummyImage
        
        addSubview(chequeImageView)
        addSubview(chequePostionLabel)
        
        NSLayoutConstraint.activate([
            
            chequeImageView.topAnchor.constraint(equalTo: topAnchor),
            chequeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chequeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chequeImageView.bottomAnchor.constraint(equalTo: chequePostionLabel.topAnchor),
            
            chequePostionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            chequePostionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            chequePostionLabel.bottomAnchor.constraint(equalTo: bottomAnchor , constant: -10),
            chequePostionLabel.heightAnchor.constraint(equalToConstant: 20)
            
        ])

    }
    
}
