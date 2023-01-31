//
//  Overlay.swift
//  MazadatImagePicker6
//
//  Created by Karim Saad on 20/11/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import UIKit

class CameraOverlay: UIView {

    var once=true
    var cameraView:CGRect!
    var topView:UIView!
    var bottomView:UIView!
    var leftView:UIView!
    var rightView:UIView!
    
    var aspectRatioX:Float = 4.0
    var aspectRatioY:Float = 3.0
    override func draw(_ rect: CGRect) {
        if(aspectRatioX>0){
            let width=rect.width * 0.91
            let height=width * CGFloat(aspectRatioY/aspectRatioX)
            cameraView = CGRect(x: rect.width/2 - width / 2, y: rect.height * 0.2 , width: width, height: height)
            
            topView=UIView(frame: CGRect(x: 0, y: 0, width: rect.width, height: cameraView.minY))
            topView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            
            bottomView=UIView(frame: CGRect(x: 0, y: cameraView.maxY, width: rect.width, height: rect.height - cameraView.maxY))
            bottomView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            
            leftView = UIView(frame: CGRect(x: 0, y: cameraView.minY, width: cameraView.minX, height: cameraView.height))
            leftView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            
            rightView = UIView(frame: CGRect(x: cameraView.maxX, y: cameraView.minY, width: rect.width - cameraView.maxX, height: cameraView.height))
            rightView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            
            addSubview(topView)
            addSubview(bottomView)
            addSubview(leftView)
            addSubview(rightView)
        }
    }
    
    
    func setAspectRatio(aspect_ratio_x:Float,aspect_ratio_y:Float){
        self.aspectRatioX = aspect_ratio_x
        self.aspectRatioY = aspect_ratio_y
        setNeedsDisplay()
    }
    
   

}
