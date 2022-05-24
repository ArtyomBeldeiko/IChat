//
//  UserError.swift
//  IChat
//
//  Created by Artyom Beldeiko on 25.05.22.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
}

extension UserError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill in all the fields.", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Photo is not available", comment: "")
        }
    }
    
}
