//
//  ButtonExtension.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 29/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import UIKit
extension UIButton {
    // Center aligned icon and bottom text
    func centerVertically(padding: CGFloat = 6.0,lang:String) {
        
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
       
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: lang == "en" ? 0 : -titleSize.width,
            bottom: 0,
            right: lang == "en" ? -titleSize.width : 0
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: lang == "en" ? -imageSize.width : 0,
            bottom: -(totalHeight - titleSize.height),
            right: lang == "en" ? 0 : -imageSize.width
        )
    }
}
