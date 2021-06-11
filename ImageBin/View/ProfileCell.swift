//
//  ProfileCell.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    
    // MARK: - Properties
    
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "BIN ICON")
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
