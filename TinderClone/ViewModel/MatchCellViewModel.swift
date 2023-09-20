//
//  MatchCellViewModel.swift
//  TinderClone
//
//  Created by Lucas Cavalcante on 25/03/22.
//

import Foundation

struct MatchCellViewModel {
    
    let nameText: String
    let profileImageUrl: URL?
    let uid: String
    
    
    init(match: Match){
        nameText = match.name
        profileImageUrl = URL(string: match.profileImageUrl)
        uid = match.uid
    }
    
}
