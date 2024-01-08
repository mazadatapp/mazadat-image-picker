//
//  UIViewControllerExtension.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 29/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    func addConstraints(currentView:UIView,MainView:UIView,centerX:Bool,centerXValue:CGFloat,
                        centerY:Bool,centerYValue:CGFloat,top:Bool,topValue:CGFloat,
                        bottom:Bool,bottomValue:CGFloat,leading:Bool,leadingValue:CGFloat,
                        trailing:Bool,trailingValue:CGFloat,width:Bool,widthValue:CGFloat,height:Bool,heightValue:CGFloat){
        
        
        currentView.translatesAutoresizingMaskIntoConstraints = false
        if(top){
            let topConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: topValue)
            MainView.addConstraint(topConst)
        }
        if(bottom){
            let bottomConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: bottomValue)
            MainView.addConstraint(bottomConst)
        }
        if(trailing){
            let trailingConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: trailingValue)
            MainView.addConstraint(trailingConst)
        }
        if(leading){
            let leadingConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: leadingValue)
            MainView.addConstraint(leadingConst)
        }
        if(centerX){
            let centerXConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: centerXValue)
            MainView.addConstraint(centerXConst)
        }
        if(centerY){
            let centerYConst = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: MainView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: centerYValue)
            MainView.addConstraint(centerYConst)
        }
        if(width){
            let widthConstraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: widthValue)
                
            MainView.addConstraint(widthConstraint)
        }
        if(height){
            let heightConstraint = NSLayoutConstraint(item: currentView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: heightValue)
            MainView.addConstraint(heightConstraint)
        }
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    func showToast(message : String,width: CGFloat) {
      
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - width/2, y: view.frame.size.height - 80, width: width, height: 35))
      toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
      toastLabel.textColor = UIColor.red
      toastLabel.font = UIFont.init(name: "Montserrat-Medium", size: 14)
      toastLabel.textAlignment = .center;
      toastLabel.text = message
      toastLabel.alpha = 1.0
      toastLabel.layer.cornerRadius = 10;
      toastLabel.clipsToBounds  =  true
      self.view.addSubview(toastLabel)
      UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
      }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
      })
    }
}
