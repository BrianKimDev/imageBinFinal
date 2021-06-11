//
//  User.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import UIKit

struct User {
    var name: String
    var email: String
    let uid: String
    var imageURLs: [String]
    var userUploads: [String]
    var discordId: String
    var minSeekingAge: Int = 18
    var maxSeekingAge: Int = 65
    var bio: String
    var socials: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.imageURLs = dictionary["imageURLs"] as? [String] ?? [String]()
        self.uid = dictionary["uid"] as? String ?? ""
        self.discordId = dictionary["discordId"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int ?? 18
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int ?? 65
        self.bio = dictionary["bio"] as? String ?? ""
        self.userUploads = dictionary["userUploads"] as? [String] ?? [String]()
        self.socials = dictionary["socials"] as? String ?? ""
    }
}
