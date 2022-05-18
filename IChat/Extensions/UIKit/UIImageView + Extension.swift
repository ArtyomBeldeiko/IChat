//
//  UIImageView + Extension.swift
//  IChat
//
//  Created by Artyom Beldeiko on 17.05.22.
//

import Foundation
import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIImageView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }

}
