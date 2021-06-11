//
//  AuthService.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import Foundation
import UIKit
import Firebase


struct AuthCredentials {
    let email: String
    let fullName: String
    let password : String
    let profilePicture: UIImage
    
}
struct AuthService {
    
    static func logUserIn(withEmail email: String,
                          password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping((Error?) ->
        Void)) {
        //print(" Register user on firebase here..")
        
        
        Service.uploadImage(image: credentials.profilePicture) { (imageUrl) in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                if let error = error {
                    print("DEBUG: Error signing user up \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data = ["email": credentials.email,
                            "fullname": credentials.fullName,
                            "userUploads": [imageUrl],
                            "uid": uid]
                            as [String : Any]
                
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
            
        }
    }
    
}
