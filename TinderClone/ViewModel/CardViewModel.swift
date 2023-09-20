//
//  CardViewModel.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 17/03/22.
//

import UIKit

class CardViewModel {
    
   let user: User
    let imageURLs: [String]
    let userInfoText: NSAttributedString
    
    private var imageIndex = 0
    
    var index: Int { return imageIndex }
    
    
    
    var imageUrl: URL?
    
    init(user: User){
        self.user = user
        
        
        
        let attributeText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy), .foregroundColor: UIColor.white ])
        
        attributeText.append(NSMutableAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24), .foregroundColor: UIColor.white ]))
        
        self.userInfoText = attributeText
        
//        self.imageUrl = URL(string: user.profileImageUrl)
        self.imageURLs = user.imageUrls
        self.imageUrl = URL(string: self.imageURLs[0])
    }
    
    func showNextPhoto() {
        guard imageIndex < imageURLs.count - 1 else { return }
        imageIndex += 1
        imageUrl = URL(string: imageURLs[imageIndex])
    }
    
    func showPreviousPhoto() {
        guard imageIndex > 0 else { return }
        imageIndex -= 1
        imageUrl = URL(string: imageURLs[imageIndex])
    }
    
    
}
