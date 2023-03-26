//
//  ImageCell.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 29/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    var image_:UIImageView!
    var editBtn:UIButton!
    var frameBlue:UIView!
    var hintL:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        frameBlue=UIView(frame: CGRect(x: 8, y: 0, width: 101, height: 76))
        frameBlue.cornerRadius = 8
        frameBlue.borderColor = Colors.blueColor()
        frameBlue.backgroundColor = UIColor.init(white: 1, alpha: 0.38)
        contentView.addSubview(frameBlue)
        
        hintL = UILabel()
        hintL.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        frameBlue.addSubview(hintL)
        hintL.textColor = UIColor(white: 0, alpha: 0.26)
        addConstraints(currentView: hintL, MainView: frameBlue, centerX: true, centerXValue: 0, centerY: true, centerYValue: 0, top: false, topValue: 0, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        image_=UIImageView(frame: CGRect(x: 2, y: 2, width: frameBlue.frame.width - 2, height: frameBlue.frame.height-2))
        image_.cornerRadius = 8
        frameBlue.addSubview(image_)
        
        let blackLayer=UIView(frame: CGRect(x: 2, y: 2, width: frameBlue.frame.width - 2, height: frameBlue.frame.height-2))
        blackLayer.cornerRadius = 8
        blackLayer.backgroundColor = UIColor(white: 0, alpha: 0.26)
        frameBlue.addSubview(blackLayer)
        
        editBtn = UIButton()
        editBtn.setImage(UIImage(named: "ic_picker_edit")?.maskWithColor(color: UIColor.white), for: .normal)
        
        editBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 9)
        frameBlue.addSubview(editBtn)
        addConstraints(currentView: editBtn, MainView: frameBlue, centerX: true, centerXValue: 0, centerY: true, centerYValue: 0, top: false, topValue: 0, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: true, heightValue: 80)
        
        
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    
}
