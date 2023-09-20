//
//  ConversationViewModel.swift
//  messageApp
//
//  Created by Lucas Cavalcante on 01/04/22.
//

import Foundation

struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversation.user.imageUrls.first!)
    }
    
    var timestamp: String{
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation){
        self.conversation = conversation
    }
}
