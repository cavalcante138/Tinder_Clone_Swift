//
//  Usee.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 17/03/22.
//

import UIKit


struct User {
    var name: String
    var age: Int
    var email: String
    let uid: String
    var imageUrls: [String]
    var profession:  String
    var minSeekingAge: Int
    var maxSeekingAge: Int
    var bio: String
    
    init(dictionary: [String: Any]){
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.imageUrls = dictionary["imageUrls"] as? [String] ?? [String]()
        self.uid = dictionary["uid"] as? String ?? ""
        self.profession = dictionary["profession"]  as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int ?? 18
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int ?? 60
        self.bio = dictionary["bio"]  as? String ?? ""
    }
    
    
}
