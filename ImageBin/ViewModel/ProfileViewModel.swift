//
//  ProfileViewModel.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//


import Foundation
import UIKit

struct ProfileViewModel {
    
    private let user: User
    
    let userDetailsAttributedString: NSAttributedString
    let discordId: String
    let bio: String
    
    
    var imageURLs: [URL] {
        return user.userUploads.map({URL(string: $0)! })
    }
    
    
    var imageCount: Int {
        return user.userUploads.count
    }
    
    init(user: User) {
        self.user = user
        
        let attributedText = NSMutableAttributedString(string: user.discordId,
                                                       attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)])
        
        attributedText.append(NSAttributedString(string: "  \(user.socials)",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 22)]))
        
        
        userDetailsAttributedString = attributedText
        
        discordId = user.discordId
        bio = user.bio
    }
}
