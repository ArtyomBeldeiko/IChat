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
    case userInfoIsNotAvailable
    case cannotUnwrapToMuser
}

extension UserError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill in all the fields.", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Photo is not available", comment: "")
        case .userInfoIsNotAvailable:
            return NSLocalizedString("User info is not available", comment: "")
        case .cannotUnwrapToMuser:
            return NSLocalizedString("The unwrapping to Muser is not available", comment: "")
        }
    }
    
}
