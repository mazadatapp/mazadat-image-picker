//
//  GallerMultiSelectController.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 23/11/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import UIKit

import PhotosUI
import Photos


@available(iOS 14.0, *)
class GallerMultiSelectController: UIViewController, PHPickerViewControllerDelegate {
    var cameraController:CameraController!
    var maxImages:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var config = PHPickerConfiguration()
        config.selectionLimit = maxImages
        config.filter = .images
        var imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var count=0
        var list=[UIImage]()
        
        for result in results{
            let itemprovider = result.itemProvider
            if itemprovider.canLoadObject(ofClass: UIImage.self){
                itemprovider.loadObject(ofClass: UIImage.self) { image , error  in
                    if let error{
                        print(error)
                    }
                    DispatchQueue.main.async { [self] in
                        if let image = image as? UIImage {
                            list.append(getCroppedImage(newImage: image))
                            count += 1
                            if(count == results.count){
                                cameraController.getCroppedImages(images: list)
                                dismiss(animated: false)
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    open func getCroppedImage(newImage:UIImage)->UIImage{
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width * 3.0 / 4.0))
        container.backgroundColor = .black
        let image=UIImageView(frame: container.frame)
        image.contentMode = .scaleAspectFit
        image.image = newImage
        container.addSubview(image)
        return container.snapshot(of: container.bounds)
        
    }
    
    func setCameraController(cameraController:CameraController,maxImages:Int){
        self.cameraController=cameraController
        self.maxImages=maxImages
    }
}
