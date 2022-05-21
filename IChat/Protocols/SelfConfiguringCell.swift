//
//  SelfConfigutingCell.swift
//  IChat
//
//  Created by Artyom Beldeiko on 21.05.22.
//

import Foundation

protocol SelfConfiguringCell {
    
    static var reuseId: String { get }
    
    func configure<U: Hashable>(with value: U)
    
}
