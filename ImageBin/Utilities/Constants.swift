//
//  Constants.swift
//  ImageBin
//
//  Created by Brian Kim on 6/10/21.
//

import Foundation
import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_SWIPES = Firestore.firestore().collection("swipes")
let COLLECTION_LIKES = Firestore.firestore().collection("likes")
let COLLECTION_DISLIKES = Firestore.firestore().collection("dislikes")
