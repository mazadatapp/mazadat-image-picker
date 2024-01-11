//
//  ImageItem.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 30/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import UIKit
class ImageItem {
    var image:UIImage!
    var path:String!
    var edited = false
    init(){
        
    }
    init(path:String){
        self.path=path
    }
    
    init(image:UIImage){
        self.image=image
    }
}
