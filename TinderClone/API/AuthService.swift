//
//  AuthService.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 19/03/22.
//

import Firebase
import UIKit

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let profileImage: UIImage
}

struct AuthService {
    
    
    static func logUserIn(withEmail email:  String, password: String, completion: AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    
    static func registerUser(withCredentias credentials: AuthCredentials, completion:  @escaping((Error?) -> Void) ) {
        Service.uploadImage(image: credentials.profileImage) { imageUrl in
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                if let error = error{
                    print("DEGUG: Error singing user up \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data = ["email": credentials.email, "fullname": credentials.fullname, "imageUrls": [imageUrl], "uid": uid, "age": 18] as [String : Any]
                
                
                COLLECTIONS_USERS.document(uid).setData(data, completion: completion)
                
            }
        }
    }
    
}
