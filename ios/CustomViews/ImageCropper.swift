//
//  CropperView.swift
//  ImageCropper
//
//  Created by MacBook Pro on 11/4/22.
//

import UIKit

class CropperView: UIView {
    
    var cropArea:CGRect!
    var once=true;
    var hasImage=false
    var area = 0
    var startPoint:CGPoint!
    var oldY:CGFloat!
    var oldX:CGFloat!
    var oldWidth:CGFloat!
    var oldHeight:CGFloat!
    var color:UIColor!
    var aspectRatioX=4.0
    var aspectRatioY=3.0
    
    //views
    var topView:UIView!
    var bottomView:UIView!
    var leftView:UIView!
    var rightView:UIView!
    
    var minXMinY:UIView!
    var minXMaxY:UIView!
    var maxXMaxY:UIView!
    var maxXMinY:UIView!
    
    var topSide:UIView!
    var bottomSide:UIView!
    var leftSide:UIView!
    var rightSide:UIView!
    
    var gridVertical1:UIView!
    var gridVertical2:UIView!
    var gridHorizontal1:UIView!
    var gridHorizontal2:UIView!
    
    var allRect:CGRect!
    var centerView:UIView!
    
    var image_:UIImageView!
    var imageView:UIView!
    
    var zoomOut:UIView!
    var zoomOutImage:UIImageView!
    
    var offsetHeight:CGFloat!
    var offsetWidth:CGFloat!
    
    var minWidth:CGFloat=100
    var allAspectRatio:CGFloat=0.0
    var insideImageHeight:Double=0.0
    var insideImageWidth:Double=0.0
    
    var minY:CGFloat = 0
    var maxY:CGFloat = 0
    var minX:CGFloat = 0
    var maxX:CGFloat = 0
    
    var angle:Float = 0.0
    override func draw(_ rect: CGRect) {
        allRect=rect
        if(once){
            
            
            color=Colors.blueColor();
            allAspectRatio=CGFloat(aspectRatioY/aspectRatioX)
            var width=rect.width*0.7;
            if(rect.width>rect.height){
                width = rect.height
                
            }
            
            imageView=UIView(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            
            image_=UIImageView(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            image_.contentMode = .scaleAspectFit
            
            let zoom_out_height=allRect.width * CGFloat(aspectRatioY/aspectRatioX)
            zoomOut=UIView(frame: CGRect(x: 0, y: allRect.height/2 - zoom_out_height/2, width: allRect.width, height: zoom_out_height))
            zoomOut.backgroundColor = .white
            
            zoomOutImage=UIImageView(frame: CGRect(x: 0, y: 0, width: zoomOut.frame.width, height: zoomOut.frame.height))
            zoomOutImage.contentMode = .scaleAspectFit
            zoomOut.addSubview(zoomOutImage)
            zoomOut.isHidden=true
            
            
            imageView.addSubview(image_)
            imageView.addSubview(zoomOut)
            addSubview(imageView)
            
            let height=width*CGFloat(aspectRatioY/aspectRatioX)
            cropArea=CGRect(x: width*0.2, y: rect.height/2 - height/2, width: width, height: height)
            once=false
            
            topView=UIView()
            topView.backgroundColor=UIColor.init(_colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
            
            bottomView=UIView()
            bottomView.backgroundColor=UIColor.init(_colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
            
            
            leftView=UIView()
            leftView.backgroundColor=UIColor.init(_colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
            
            rightView=UIView()
            rightView.backgroundColor=UIColor.init(_colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
            
            addSubview(topView)
            addSubview(bottomView)
            addSubview(leftView)
            addSubview(rightView)
            
            //grid
            
            topSide=UIView()
            topSide.backgroundColor=color
            bottomSide=UIView()
            bottomSide.backgroundColor=color
            
            leftSide=UIView()
            leftSide.backgroundColor=color
            
            rightSide=UIView()
            rightSide.backgroundColor=color
            
            minXMinY=UIView()
            minXMinY.backgroundColor=color
            minXMinY.cornerRadius=10
            minXMaxY=UIView()
            minXMaxY.backgroundColor=color
            minXMaxY.cornerRadius=10
            maxXMinY=UIView()
            maxXMinY.backgroundColor=color
            maxXMinY.cornerRadius=10
            maxXMaxY=UIView()
            maxXMaxY.backgroundColor=color
            maxXMaxY.cornerRadius=10
            
            
            gridVertical1=UIView()
            gridVertical1.backgroundColor = color
            
            gridVertical2=UIView()
            gridVertical2.backgroundColor = color
            
            gridHorizontal1 = UIView()
            gridHorizontal1.backgroundColor = color
            
            gridHorizontal2 = UIView()
            gridHorizontal2.backgroundColor = color
            
            
            
            centerView=UIView(frame: cropArea)
            //centerView.backgroundColor = UIColor.init(red: 255, green: 0, blue: 0, alpha: 0.4)
            
            
            addSubview(centerView)
            addSubview(topSide)
            addSubview(bottomSide)
            addSubview(leftSide)
            addSubview(rightSide)
            
            addSubview(minXMinY)
            addSubview(minXMaxY)
            addSubview(maxXMinY)
            addSubview(maxXMaxY)
            
            addSubview(gridVertical1)
            addSubview(gridVertical2)
            addSubview(gridHorizontal1)
            addSubview(gridHorizontal2)
        }
        
        centerView.frame = cropArea
        topView.frame = CGRect(x: 0, y: 0, width: rect.width, height: cropArea.minY)
        bottomView.frame = CGRect(x: 0, y: cropArea.maxY, width: rect.width, height: rect.height-cropArea.maxY)
        leftView.frame = CGRect(x: 0, y: cropArea.minY, width: cropArea.minX, height: cropArea.maxY - cropArea.minY)
        rightView.frame = CGRect(x: cropArea.maxX, y: cropArea.minY, width: rect.width - cropArea.maxX, height: cropArea.maxY - cropArea.minY)
        
        topSide.frame = CGRect(x: cropArea.minX, y: cropArea.minY-1, width: cropArea.maxX - cropArea.minX, height: 2)
        bottomSide.frame = CGRect(x: cropArea.minX, y: cropArea.maxY-1, width: cropArea.maxX - cropArea.minX, height: 2)
        leftSide.frame = CGRect(x: cropArea.minX - 1, y: cropArea.minY, width: 2, height: cropArea.maxY - cropArea.minY)
        rightSide.frame = CGRect(x: cropArea.maxX - 1, y: cropArea.minY, width: 2, height: cropArea.maxY - cropArea.minY)
        
        minXMinY.frame = CGRect(x: cropArea.minX-10,y: cropArea.minY-10,width: 20,height: 20)
        minXMaxY.frame = CGRect(x: cropArea.minX-10,y: cropArea.maxY-10,width: 20,height: 20)
        maxXMinY.frame = CGRect(x: cropArea.maxX-10,y: cropArea.minY-10,width: 20,height: 20)
        maxXMaxY.frame = CGRect(x: cropArea.maxX-10,y: cropArea.maxY-10,width: 20,height: 20)
        
        gridVertical1.frame = CGRect(x: cropArea.minX + ((cropArea.maxX - cropArea.minX) * 0.33) - 0.5, y: cropArea.minY, width: 1, height: cropArea.maxY - cropArea.minY)
        gridVertical2.frame = CGRect(x: cropArea.minX + ((cropArea.maxX - cropArea.minX) * 0.66) - 0.5, y: cropArea.minY, width: 1, height: cropArea.maxY - cropArea.minY)
        gridHorizontal1.frame = CGRect(x: cropArea.minX, y: cropArea.minY + ((cropArea.maxY - cropArea.minY) * 0.33) - 0.5, width: cropArea.maxX - cropArea.minX, height: 1)
        gridHorizontal2.frame = CGRect(x: cropArea.minX, y: cropArea.minY + ((cropArea.maxY - cropArea.minY) * 0.66) - 0.5, width: cropArea.maxX - cropArea.minX, height: 1)
        
        
    }
    
    
    open func getCropView()->UIView{
        return centerView
    }
    open func getCroppedArea()->CGRect{
        return cropArea
    }
    
    open func setImage(image:UIImage){
        image_.image=image
        zoomOutImage.image=image
        
        
        setMargins()
    }
    open func getCroppedImage()->UIImage{
        let container = UIView(frame: CGRect(x: 0, y: 0, width: allRect.width, height: allRect.width * aspectRatioY / aspectRatioX))
        container.backgroundColor = .black
        let image=UIImageView(frame: CGRect(x: 0, y: 0, width: allRect.width, height: allRect.width * aspectRatioY / aspectRatioX))
        image.contentMode = .scaleAspectFit
        image.image = imageView.snapshot(of: cropArea)
        container.addSubview(image)
        return container.snapshot(of: container.bounds)
        
    }
    
    open func setAspectRatio(aspect_ratio_x:Float,aspect_ratio_y:Float){
        self.aspectRatioX=Double(aspect_ratio_x)
        self.aspectRatioY=Double(aspect_ratio_y)
        setMargins()
    }
    func setMargins(){
        let imageViewHeight = image_.bounds.height
        let imageViewWidth = image_.bounds.width
        let imageSize = image_.image!.size
        insideImageHeight = Double(min(imageSize.height * (imageViewWidth / imageSize.width), imageViewHeight))
        insideImageWidth = Double(min(imageSize.width * (imageViewHeight / imageSize.height), imageViewWidth))
        
        minY=(allRect.height - CGFloat(insideImageHeight)) / 2
        maxY = minY + CGFloat(insideImageHeight)
        
        minX=(allRect.width - CGFloat(insideImageWidth)) / 2
        maxX = minX + CGFloat(insideImageWidth)
        
        var width=allRect.width*0.7;
        if(allRect.width>allRect.height){
            width = allRect.height
        }
        let height=width*CGFloat(aspectRatioY/aspectRatioX)
        cropArea=CGRect(x: width*0.2, y: allRect.height/2 - height/2, width: width, height: height)
        
        setNeedsDisplay()
        
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint=touches.first!.location(in: self)
        let touchArea:CGFloat=60
        let rect_minX_minY=CGRect(x: cropArea.minX-touchArea/2,y: cropArea.minY-touchArea/2,width: touchArea,height: touchArea)
        let rect_maxX_minY=CGRect(x: cropArea.maxX-touchArea/2,y: cropArea.minY-touchArea/2,width: touchArea,height: touchArea)
        let rect_maxX_maxY=CGRect(x: cropArea.maxX-touchArea/2,y: cropArea.maxY-touchArea/2,width: touchArea,height: touchArea)
        let rect_minX_maxY=CGRect(x: cropArea.minX-touchArea/2,y: cropArea.maxY-touchArea/2,width: touchArea,height: touchArea)
        
        let side_top=CGRect(x: cropArea.minX+touchArea/2,y: cropArea.minY-touchArea/2,width: cropArea.maxX - cropArea.minX - touchArea,height: touchArea)
        let side_bottom=CGRect(x: cropArea.minX+touchArea/2,y: cropArea.maxY-touchArea/2,width: cropArea.maxX - cropArea.minX - touchArea,height: touchArea)
        let side_left=CGRect(x: cropArea.minX-touchArea/2, y: cropArea.minY+touchArea/2, width: touchArea, height: cropArea.maxY - cropArea.minX - touchArea)
        let side_right=CGRect(x: cropArea.maxX-touchArea/2, y: cropArea.minY+touchArea/2, width: touchArea, height: cropArea.maxY - cropArea.minX - touchArea)
        
        let rect_all=CGRect(x: cropArea.minX,y: cropArea.minY,width: cropArea.maxX - cropArea.minX,height: cropArea.maxY - cropArea.minY)
        
        
        if(rect_minX_minY.contains(startPoint)){
            area = 1
        }else if(rect_maxX_minY.contains(startPoint)){
            area = 2
        }else if(rect_minX_maxY.contains(startPoint)){
            area = 3
        }else if(rect_maxX_maxY.contains(startPoint)){
            area = 4
        }else if(side_top.contains(startPoint)){
            area = 5
        }else if(side_right.contains(startPoint)){
            area = 6
        }else if(side_bottom.contains(startPoint)){
            area = 7
        }else if(side_left.contains(startPoint)){
            area = 8
        }else if(rect_all.contains(startPoint)){
            area = 9
            offsetHeight=cropArea.maxY - startPoint.y
            offsetWidth=cropArea.maxX - startPoint.x
        }
        
        
        oldX=cropArea.origin.x
        oldY=cropArea.origin.y
        oldWidth=cropArea.width
        oldHeight=cropArea.height
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        
        let y=point.y - startPoint.y
        let x=point.x - startPoint.x
        
        let area_6_expression = oldY - x/2 + (oldWidth + x)
        let area_8_expression = oldY + x/2 + (oldWidth - x)
        
        if(area == 1 && oldWidth-x > minWidth &&
           oldHeight - y > minWidth &&
           oldY+y > minY &&
           oldX+x > minX){
            cropArea.origin.x=oldX+x
            cropArea.origin.y=oldY+y
            cropArea.size.width=oldWidth-x
            cropArea.size.height = oldHeight-y
            setNeedsDisplay()
            
        }else if(area == 2 && oldWidth+x > minWidth &&
                 oldHeight - y > minWidth &&
                 oldY+y > minY &&
                 cropArea.minX + oldWidth + x < maxX){
            cropArea.origin.y=oldY+y
            cropArea.size.width=oldWidth+x
            cropArea.size.height = oldHeight - y
            setNeedsDisplay()
        }else if(area == 3 && oldWidth-x > minWidth &&
                 oldHeight + y > minWidth &&
                 cropArea.minY + oldHeight + y < maxY &&
                 oldX + x > minX){
            cropArea.origin.x=oldX+x
            cropArea.size.width=oldWidth-x
            cropArea.size.height = oldHeight + y
            setNeedsDisplay()
        }else if(area == 4 && oldWidth+x > minWidth &&
                 oldHeight + y > minWidth &&
                 cropArea.minY + oldHeight + y < maxY &&
                 cropArea.minX + oldWidth + x < maxX){
            cropArea.size.width=oldWidth+x
            cropArea.size.height = oldHeight+y
            
            setNeedsDisplay()
        }else if(area == 5 && oldHeight-y > minWidth &&
                 oldY + y > minY){
            cropArea.origin.y=oldY+y
            cropArea.size.height = oldHeight - y
            setNeedsDisplay()
        }else if(area == 6 && oldWidth+x > minWidth &&
                 x + oldX + oldWidth < maxY){
            
            cropArea.size.width=oldWidth+x
            
            setNeedsDisplay()
        }else if(area == 7 && oldHeight+y > minWidth &&
                 oldY + oldHeight + y < maxY){
            //cropArea.origin.y=old_y+y
            
            cropArea.size.height = oldHeight + y
            setNeedsDisplay()
        }else if(area == 8 && oldWidth-x > minWidth &&
                 (oldX + x) > minX){
            
            cropArea.origin.x=oldX+x
            cropArea.size.width=oldWidth-x
            
            
            setNeedsDisplay()
        }else if(area == 9){
            if(oldX+x>0 && offsetWidth + point.x<allRect.width){
                cropArea.origin.x=oldX+x
                setNeedsDisplay()
            }
            if(oldY+y > minY && offsetHeight + point.y < maxY){
                cropArea.origin.y=oldY+y
                setNeedsDisplay()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        area=0
    }
    
    
}
