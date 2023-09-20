//
//  MatchViewModel.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 25/03/22.
//

import Foundation


struct MatchViewViewModel{
    
    
    private let currentUser: User
    let matchedUser: User
    
    let matchLabelText: String
    var currentUserImageUrl: URL?
    var matchedUserImageURl: URL?
    
    
    
    init(currentUser: User, matchedUser: User){
        self.currentUser = currentUser
        self.matchedUser = matchedUser
        
        matchLabelText = "You and \(matchedUser.name) have liked each other!"
        
        guard let imageUrlString = currentUser.imageUrls.first else {  return }
        guard let matchedImageUrlString = matchedUser.imageUrls.first else {  return }
        
        currentUserImageUrl = URL(string: imageUrlString)
        matchedUserImageURl = URL(string: matchedImageUrlString)
        
    }
    
    
}
