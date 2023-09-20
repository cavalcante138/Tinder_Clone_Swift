//
//  ProfileViewModel.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 23/03/22.
//

import Foundation
import UIKit


struct ProfileViewModel{
    
    private let user: User
    
    let userDetailsAttributeString: NSAttributedString
    let profession: String
    let bio: String
    
    var imageURLs: [URL] {
        return user.imageUrls.map({ URL(string: $0)! })
    }
    
    var imageCount: Int{
        return user.imageUrls.count
    }
    
    
    
    init(user: User){
        self.user = user
        
        let attributeText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .semibold)])
        
        attributeText.append(NSAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 22)]))
        
        userDetailsAttributeString = attributeText
        
        profession = user.profession
        bio = user.bio
    }
    
}
