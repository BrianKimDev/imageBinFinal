//
//  CardViewModel.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import UIKit

class CardViewModel {
    
    let user: User
    let userUploads: [String]
    let userInfoText: NSAttributedString
    private var imageIndex = 0
    var index: Int {return imageIndex}
    var imageURL: URL?
    
    
    init(user: User) {
        self.user = user
        let attributedText = NSMutableAttributedString(string: user.name, attributes:
                                                        [.font: UIFont.systemFont(ofSize: 30, weight: .heavy), .foregroundColor: UIColor.white])
        
        attributedText.append(NSAttributedString(string: "   \(user.socials)", attributes:
                                                    [.font: UIFont.systemFont(ofSize: 24),
                                                     .foregroundColor: UIColor.white]))
        
        self.userInfoText = attributedText
        
        
        self.userUploads = user.userUploads
        self.imageURL = URL(string: self.userUploads[0])
        
    }
    
    func showNextPhoto() {
        // the imageIndex was trying to go to 2 but it only has 0,1 on the index
        guard imageIndex < userUploads.count - 1 else { return }
        // make sure the image index is less than  user.images.count - 1 after being increased by 1
        imageIndex += 1
        imageURL = URL(string: userUploads[imageIndex])
        
        
    }
    
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        imageURL = URL(string: userUploads[imageIndex])
        
    }
}
