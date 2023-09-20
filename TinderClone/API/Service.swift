//
//  Service.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 19/03/22.
//

import Foundation
import Firebase


struct Service {
    
    
    static func fetchUser(withUid uid:  String, completion: @escaping(User) -> Void){
        COLLECTIONS_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(forCurrentUser user: User, completion: @escaping([User]) -> Void){
        var users = [User]()
        
        
        let query = COLLECTIONS_USERS.whereField("age", isGreaterThanOrEqualTo: user.minSeekingAge).whereField("age", isLessThanOrEqualTo: user.maxSeekingAge)
        
        fetchSwipes { swipedUserIds in
            query.getDocuments { snapshot, error in
                
                guard let snapshot = snapshot else {  return }
                
                snapshot.documents.forEach({ document in
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                    
                    
                    guard user.uid != Auth.auth().currentUser?.uid else {  return }
                    guard swipedUserIds[user.uid] ==  nil else { return }
                    
                    users.append(user)
                })
                completion(users)
//                if users.count == snapshot.documents.count - 1 {
//                    completion(users)
//                }
            }
            
        }
        

    }
    
    private static func fetchSwipes(completion: @escaping([String: Bool]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() as? [String: Bool] else {
                completion([String: Bool]())
                return
            }
            
            completion(data)
        }
    }
    
    static func fetchMatches(completion: @escaping([Match]) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_MATCHES_MESSAGES.document(uid).collection("matches").getDocuments { snapshot, error in
            guard let data = snapshot else { return }
            let matches = data.documents.map({ Match(dictionary: $0.data()) })
            completion(matches)
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping(([Message]) -> Void)){
        var messages = [Message]()
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTIONS_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["text": message, "fromId": currentUid, "toId": user.uid, "timestamp": Timestamp(date: Date())] as [String : Any]
        
        COLLECTIONS_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
            COLLECTIONS_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            COLLECTIONS_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
            
            COLLECTIONS_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
        }
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        
        var conversations = [Conversation]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTIONS_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                
                
                self.fetchUser(withUid: message.chatPartnerId) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
                

            })
        }
    }
    
    
    
    static func saveUserData(user: User, completion: @escaping(Error?) -> Void){
        let data = ["uid": user.uid,
                    "fullname": user.name,
                    "imageUrls" : user.imageUrls, "age": user.age, "email": user.email, "bio": user.bio,
                    "profession": user.profession, "minSeekingAge": user.minSeekingAge, "maxSeekingAge": user.maxSeekingAge] as [String : Any]
        
        COLLECTIONS_USERS.document(user.uid).setData(data, completion: completion)
    }
    
    static func saveSwipe(forUser user: User, isLike: Bool, completion: ((Error?) -> Void)? ){
        guard let uid = Auth.auth().currentUser?.uid else {  return }
//        let shouldLike = isLike ? 1 : 0
        
        COLLECTION_SWIPES.document(uid).getDocument { snapshot, error in
            let data = [user.uid: isLike]
            
            
            if snapshot?.exists == true{
                COLLECTION_SWIPES.document(uid).updateData(data, completion: completion)
            } else{
                COLLECTION_SWIPES.document(uid).setData(data, completion: completion)
            }
        }
    }
    
    
    static func checkIfMatchExists(forUser user: User, completion: @escaping(Bool) -> Void){
        
        guard let currentUid = Auth.auth().currentUser?.uid else {  return }
        
        COLLECTION_SWIPES.document(user.uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else {  return }
            guard let didMatch = data[currentUid] as? Bool else { return }
            completion(didMatch)
        }
        
    }
    
    static func uploadMatch(currentUser: User, matchedUser: User){
        guard let profileImageUrl = matchedUser.imageUrls.first else { return }
        guard let currentUserProfileImageUrl = currentUser.imageUrls.first else { return }
        
        let matchedUserdata = ["uid": matchedUser.uid, "name": matchedUser.name, "profileImageUrl": profileImageUrl]
        
        COLLECTION_MATCHES_MESSAGES.document(currentUser.uid).collection("matches").document(matchedUser.uid).setData(matchedUserdata)
        
        
        let currentUserData = ["uid": currentUser.uid, "name": currentUser.name, "profileImageUrl": currentUserProfileImageUrl]
        
        COLLECTION_MATCHES_MESSAGES.document(matchedUser.uid).collection("matches").document(currentUser.uid).setData(currentUserData)
        
        
    }
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void){
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error{
                print("DEGUG: Error upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
            
            
        }
        
    }
}

