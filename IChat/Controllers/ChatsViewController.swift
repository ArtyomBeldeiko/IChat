//
//  ChatsViewController.swift
//  IChat
//
//  Created by Artyom Beldeiko on 29.05.22.
//

import Foundation
import UIKit
import MessageKit

class ChatsViewController: MessagesViewController {
    
    private let user: MUSer
    private let chat: MChat
    
    init(user: MUSer, chat: MChat) {
        self.user = user
        self.chat = chat
        
        super.init(nibName: nil, bundle: nil)
        
        title = chat.friendUsername
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
    }
    
    
    
}

extension ChatsViewController: MessagesDataSource {
    
    var currentSender: SenderType {
        
        return 
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        <#code#>
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        return 1
    }
    
}
