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
    
    func rotate(radians: CGFloat) -> UIImage {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func saveImage(name:String)->URL{
      var fileName = getDocumentsDirectory().appendingPathComponent(name)
        if let data = jpegData(compressionQuality: 0.5) {
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
}
