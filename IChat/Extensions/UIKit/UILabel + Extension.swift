//
//  UILabel + Extension.swift
//  IChat
//
//  Created by Artyom Beldeiko on 17.05.22.
//

import Foundation
import UIKit


extension UILabel {
    
    convenience init(text: String, font: UIFont? = .avenir20()) {
        self.init()
        
        self.text = text
        self.font = font 
    }
}
