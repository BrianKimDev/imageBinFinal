//
//  BottomControllsStackView.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import UIKit

protocol BottomControlsStackViewDelegate: AnyObject {
    func handleDislike()
    func handleRefresh()
    func handleLike()
}

class BottomControlsStackView: UIStackView {
    
    // MARK: - Properties
    
    weak var delegate: BottomControlsStackViewDelegate?
    
    
    
    let refreshButton = UIButton(type: .system)
    let dislikeButton = UIButton(type: .system)
    let likeButton = UIButton(type: .system)
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)

        dislikeButton.imageView?.contentMode = .scaleAspectFit
        dislikeButton.setDimensions(height: 45, width: 45)
        refreshButton.imageView?.contentMode = .scaleAspectFit
        refreshButton.setDimensions(height: 25, width: 25)
        likeButton.imageView?.contentMode = .scaleAspectFit
        likeButton.setDimensions(height: 45, width: 45)
        
        
        refreshButton.setImage(#imageLiteral(resourceName: "BACK").withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(#imageLiteral(resourceName: "DISLIKE").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "LIKE").withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        
        [dislikeButton, refreshButton, likeButton]
            .forEach { view in
                addArrangedSubview(view)
            }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
        delegate?.handleRefresh()
    }
    
    @objc func handleDislike() {
        delegate?.handleDislike()
    }
    
    @objc func handleLike() {
        delegate?.handleLike()
    }
    
}
