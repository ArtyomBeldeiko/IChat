//
//  MUser.swift
//  IChat
//
//  Created by Artyom Beldeiko on 21.05.22.
//

import Foundation
import UIKit

struct MUSer: Hashable, Decodable {
    var username: String
    var email: String
    var avatarStringURL: String
    var description: String
    var sex: String
    var id: String
    
    var representation: [String:Any] {
        
        var rep = ["username": username]
        rep["email"] = email
        rep["avatarStringURL"] = avatarStringURL
        rep["description"] = description
        rep["sex"] = sex
        rep["uid"] = id
        
        return rep 
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MUSer, rhs: MUSer) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filter: String?) -> Bool {
        
        guard let filter = filter else { return true }
        
        if filter.isEmpty { return true }
        
        let lowercasedFilter = filter.lowercased()
        
        return username.lowercased().contains(lowercasedFilter)

        
    }
}
