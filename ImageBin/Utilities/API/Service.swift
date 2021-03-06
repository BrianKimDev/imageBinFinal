//
//  Service.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import Foundation
import Firebase

struct Service {
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
        
    }
    
    static func fetchUsers(forCurrentUser user: User, completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        
        
        let query = COLLECTION_USERS
        
        
        
        fetchSwipes { swipedUserIDs in
            query.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                snapshot.documents.forEach({ document in
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                    
                    guard user.uid != Auth.auth().currentUser?.uid else { return }
                    guard swipedUserIDs[user.uid] == nil else { return }
                    users.append(user)
                    
                })
                completion(users)
            }
            
        }
    }
    
    // get back the dictionary of swiped user data on firebase
    private static func fetchSwipes(completion: @escaping([String: Bool]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() as? [String: Bool] else {
                completion([String: Bool]())
                return
            }
            
            completion(data)
            
        }
        
    }
    
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void) {
        
        let data = ["uid": user.uid,
                    "fullname": user.name,
                    "userUploads": user.userUploads,
                    "email": user.email,
                    "imageURLs": user.imageURLs,
                    "bio": user.bio,
                    "discordId": user.discordId,
                    "minSeekingAge": user.minSeekingAge,
                    "maxSeekingAge": user.maxSeekingAge] as [String : Any] as [String : Any]
        
        COLLECTION_USERS.document(user.uid).setData(data, completion: completion)
    }
    
    static func saveSwipeForUser(forUser user: User, isLike: Bool, completion: ((Error?) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { (snapshot, error) in
            let data = [user.uid: isLike]
            
            if snapshot?.exists == true {
                COLLECTION_SWIPES.document(uid).updateData(data, completion: completion)
            } else {
                COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    static func checkIfMatchExists(forUser user: User, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(user.uid).getDocument { (snapshot, error) in
            guard let data = snapshot?.data() else { return }
            guard let didMatch = data[currentUid] as? Bool else { return }
            completion(didMatch)
        }
    }
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: " /images/\(fileName)")
        
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("DEBUG: Error uploading image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let imageURL = url?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
    
}
