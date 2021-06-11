//
//  HomeNavigationStackView.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import UIKit

// Delegate action back to controller
protocol HomeNavigationStackViewDelegate: AnyObject {
    func showSettings()
    func showUploadImage()
}

class HomeNavigationStackView: UIStackView {
    
    // MARK: - Properties
    
    // avoid retain cycle
    weak var delegate: HomeNavigationStackViewDelegate?
    
    let settingsButton = UIButton(type: .system)
    let uploadImageButton = UIButton(type: .system)
    let duoIcon = UIImageView(image: #imageLiteral(resourceName: "BIN ICON"))
    
    
    
    
    // MARK: - lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        duoIcon.contentMode = .scaleAspectFit
        duoIcon.setDimensions(height: 45, width: 45)
       
        settingsButton.imageView?.contentMode = .scaleAspectFit
        settingsButton.setDimensions(height: 45, width: 45)
        uploadImageButton.imageView?.contentMode = .scaleAspectFit
        uploadImageButton.setDimensions(height: 45, width: 45)
        
        
        
        settingsButton.setImage(#imageLiteral(resourceName: "PROFILE").withRenderingMode(.alwaysOriginal), for: .normal)
        uploadImageButton.setImage(#imageLiteral(resourceName: "RANKING").withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        [settingsButton, UIView(), duoIcon, UIView(), uploadImageButton].forEach { view in
            addArrangedSubview(view)
        }
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingsButton.addTarget(self, action: #selector(handleShowSettings), for: .touchUpInside)
        uploadImageButton.addTarget(self, action: #selector(handleShowMessage), for: .touchUpInside)
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleShowSettings() {
        delegate?.showSettings()
    }
    
    @objc func handleShowMessage() {
        delegate?.showUploadImage()
    }
    
    
}
