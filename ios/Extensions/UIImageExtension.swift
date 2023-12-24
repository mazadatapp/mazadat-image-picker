//
//  UIImageExtension.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 29/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    func rotate(angle: CGFloat) -> UIImage {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(angle))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(angle))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func rotate(radians: CGFloat) -> UIImage {
        
        let cgImage = self.cgImage!
        let LARGEST_SIZE = CGFloat(max(self.size.width, self.size.height))
        let context = CGContext.init(data: nil, width:Int(LARGEST_SIZE), height:Int(LARGEST_SIZE), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)!
        
        var drawRect = CGRect.zero
        drawRect.size = self.size
        let drawOrigin = CGPoint(x: (LARGEST_SIZE - self.size.width) * 0.5,y: (LARGEST_SIZE - self.size.height) * 0.5)
        drawRect.origin = drawOrigin
        var tf = CGAffineTransform.identity
        tf = tf.translatedBy(x: LARGEST_SIZE * 0.5, y: LARGEST_SIZE * 0.5)
        tf = tf.rotated(by: -CGFloat(radians))
        tf = tf.translatedBy(x: LARGEST_SIZE * -0.5, y: LARGEST_SIZE * -0.5)
        context.concatenate(tf)
        context.draw(cgImage, in: drawRect)
        var rotatedImage = context.makeImage()!
        drawRect = drawRect.applying(tf)
        
        rotatedImage = rotatedImage.cropping(to: drawRect)!
        let resultImage = UIImage(cgImage: rotatedImage)
        return resultImage
        
        
    }
    
    func rotateExif(angle: CGFloat) -> UIImage{
        var orientation : UIImage.Orientation!
        
        switch(Int(angle * -180 / .pi)){
        case 0:
            orientation = .up
            break
        case 90:
            orientation = .right
            break
        case 180:
            orientation = .down
            break
        case 270:
            orientation = .left
            break
        default:
            orientation = .down
        }
        
        if(orientation == UIImage.Orientation.up){return self}
        
        let current = self.imageOrientation
        let currentDegrees: Int = (
            current == UIImage.Orientation.down || current == UIImage.Orientation.downMirrored ? 180 : (
                current == UIImage.Orientation.left || current == UIImage.Orientation.leftMirrored ? 270 : (
                    current == UIImage.Orientation.right || current == UIImage.Orientation.rightMirrored ? 90 : 0
                )
            )
        )
        let changeDegrees: Int = (
            orientation == UIImage.Orientation.downMirrored || orientation == UIImage.Orientation.downMirrored ? 180 : (
                orientation == UIImage.Orientation.left || orientation == UIImage.Orientation.leftMirrored ? 270 : (
                    orientation == UIImage.Orientation.right || orientation == UIImage.Orientation.rightMirrored ? 90 : 0
                )
            )
        )
        
        
        let mirrored: Bool = (
            current == UIImage.Orientation.downMirrored || current == UIImage.Orientation.upMirrored ||
            current == UIImage.Orientation.leftMirrored || current == UIImage.Orientation.rightMirrored ||
            orientation == UIImage.Orientation.downMirrored || orientation == UIImage.Orientation.upMirrored ||
            orientation == UIImage.Orientation.leftMirrored || orientation == UIImage.Orientation.rightMirrored
        )
        
        let degrees: Int = currentDegrees + changeDegrees
        
        let newOrientation: UIImage.Orientation = (
            degrees == 270 || degrees == 630 ? (mirrored ? UIImage.Orientation.leftMirrored : UIImage.Orientation.left) : (
                degrees == 180 || degrees == 540 ? (mirrored ? UIImage.Orientation.downMirrored : UIImage.Orientation.down) : (
                    degrees == 90 || degrees == 450 ? (mirrored ? UIImage.Orientation.rightMirrored : UIImage.Orientation.right) : (
                        mirrored ? UIImage.Orientation.upMirrored : UIImage.Orientation.up
                    )
                )
            )
        )
        
        return UIImage(cgImage: self.cgImage!, scale: 1.0, orientation: newOrientation)
    }
    
    func saveImage(name:String)->URL{
        let fileName = getDocumentsDirectory().appendingPathComponent(name)
        if let data = jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileName)
        }
        return fileName
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func croppedImage(inRect rect: CGRect) -> UIImage {
        let rad: (Double) -> CGFloat = { deg in
            return CGFloat(deg / 180.0 * .pi)
        }
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .left:
            let rotation = CGAffineTransform(rotationAngle: rad(90))
            rectTransform = rotation.translatedBy(x: 0, y: -size.height)
        case .right:
            let rotation = CGAffineTransform(rotationAngle: rad(-90))
            rectTransform = rotation.translatedBy(x: -size.width, y: 0)
        case .down:
            let rotation = CGAffineTransform(rotationAngle: rad(-180))
            rectTransform = rotation.translatedBy(x: -size.width, y: -size.height)
        default:
            rectTransform = .identity
        }
        rectTransform = rectTransform.scaledBy(x: scale, y: scale)
        let transformedRect = rect.applying(rectTransform)
        let imageRef = cgImage!.cropping(to: transformedRect)!
        let result = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        return result
    }
    
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
