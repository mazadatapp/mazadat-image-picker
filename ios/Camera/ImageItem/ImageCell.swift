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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let frame=UIView(frame: CGRect(x: 8, y: 0, width: 101, height: 76))
        frame.cornerRadius = 8
        frame.borderWidth=2
        frame.borderColor = Colors.blueColor()
        frame.backgroundColor = UIColor.init(white: 1, alpha: 0.38)
        contentView.addSubview(frame)
        
        image_=UIImageView(frame: CGRect(x: 2, y: 2, width: frame.frame.width - 2, height: frame.frame.height-2))
        image_.cornerRadius = 8
        frame.addSubview(image_)
        
        editBtn = UIButton()
        editBtn.setImage(UIImage(named: "ic_picker_edit")?.maskWithColor(color: UIColor.white), for: .normal)
        
        editBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 9)
        frame.addSubview(editBtn)
        addConstraints(currentView: editBtn, MainView: frame, centerX: true, centerXValue: 0, centerY: true, centerYValue: 0, top: false, topValue: 0, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: true, heightValue: 80)
        
        
        
        
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
