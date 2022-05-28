//
//  WaitingChatNavigation.swift
//  IChat
//
//  Created by Artyom Beldeiko on 29.05.22.
//

import Foundation


protocol WaitingChatNavigation: AnyObject {
    
    func removeWaitingChat(chat: MChat)
    func chatToActive(chat: MChat)

}
