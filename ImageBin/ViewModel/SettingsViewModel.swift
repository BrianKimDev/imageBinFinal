//
//  SettingsViewModel.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import Foundation


enum SettingsSection: Int, CaseIterable {
    case discordID
    case socials
    case bio
    
    
    
    
    var description: String {
        switch self {
        case .socials: return "your socials"
        case .discordID: return "Discord ID"
        case .bio: return "Bio"
            
        }
    }
    
}




struct SettingsViewModel {
    
    private let user: User
    let section: SettingsSection
    
    let placeHolderText: String
    var value: String?
    
    
    
    
    
    init(user: User, section: SettingsSection) {
        self.user = user
        self.section = section
        
        placeHolderText = ("Enter \(section.description.lowercased()) here...")
        
        
        switch section {
        
        case .discordID:
            value = user.discordId
        case .socials:
            value = user.socials
        case .bio:
            value = user.bio
            break
        }
    }
    
}
