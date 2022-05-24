//
//  AuthNavigationDelegate.swift
//  IChat
//
//  Created by Artyom Beldeiko on 24.05.22.
//

import Foundation

protocol AuthNavigationDelegate: AnyObject {
    
    func toLoginVC()
    func toSignUpVC()
    
}
