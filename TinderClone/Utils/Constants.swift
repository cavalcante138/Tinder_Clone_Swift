//
//  Constants.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 19/03/22.
//

import Firebase

let COLLECTIONS_USERS = Firebase.Firestore.firestore().collection("users")
let COLLECTION_SWIPES = Firebase.Firestore.firestore().collection("swipes")
let COLLECTION_MATCHES_MESSAGES = Firebase.Firestore.firestore().collection("matches_messages")
let COLLECTIONS_MESSAGES = Firebase.Firestore.firestore().collection("messages")
