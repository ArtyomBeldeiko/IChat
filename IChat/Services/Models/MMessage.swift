//
//  MMessage.swift
//  IChat
//
//  Created by Artyom Beldeiko on 28.05.22.
//

import UIKit
import FirebaseFirestore

struct MMessage: Hashable {
    
    let content: String
    let senderId: String
    let senderUsername: String
    var sentDate: Date
    let id: String?
    
    init(user: MUSer, content: String) {
        
        self.content = content
        senderId = user.id
        senderUsername = user.username
        sentDate = Date()
        id = nil
        
    }
    
    init?(document: QueryDocumentSnapshot) {
        
        let data = document.data()
        
        guard let sentDate = data["created"] as? Timestamp else { return nil }
        guard let senderId = data["senderID"] as? String else { return nil }
        guard let senderUsername = data["senderName"] as? String else { return nil }
        guard let content = data["content"] as? String else { return nil }
        
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        self.senderUsername = senderUsername
        self.content = content
        self.senderId = senderId
    }
    
    
    var representation: [String: Any] {
        
        var rep: [String: Any] = [
            "created" : sentDate,
            "senderId" : senderId,
            "senderUsername" : senderUsername,
            "content" : content
        ]
        
        return rep
        
    }
    
}
