//
//  UIImageViewExtention.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 02/02/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{

    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
        
        pinchGesture.scale = 1
      }

      @objc
      private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
      }
    
   
}
