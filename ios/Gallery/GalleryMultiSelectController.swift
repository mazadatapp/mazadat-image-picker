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
class GalleryMultiSelectController: UIViewController, PHPickerViewControllerDelegate {
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
        var hasError=false
        if(results.count>0){
            addUI()
            
            for result in results{
                let itemprovider = result.itemProvider
                if itemprovider.canLoadObject(ofClass: UIImage.self){
                    itemprovider.loadObject(ofClass: UIImage.self) { image , error  in
                        if let error{
                            print(error)
                        }
                        
                        DispatchQueue.main.async { [self] in
                            if var image = image as? UIImage {
                                var imgData = image.jpegData(compressionQuality: 1)!
                                var imageSize: Int = imgData.count
                                count += 1
                                if(imageSize <= 5000000){
                                    if(imageSize > 2000000){
                                        imgData = image.jpegData(compressionQuality: CGFloat(4000000)/CGFloat(imageSize))!
                                        imageSize = imgData.count
                                        image = UIImage(data: imgData)!
                                    }
                                    
                                    list.append(getCroppedImage(newImage: image))
                                    
                                    if(count == results.count){
                                        cameraController.getImagesFromGallery(images: list, hasError: hasError)
                                        dismiss(animated: false)
                                    }
                                }else{
                                    hasError = true
                                    if(count == results.count){
                                        cameraController.getImagesFromGallery(images: list, hasError: hasError)
                                        dismiss(animated: false)
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    }
                }
            }
        }else{
            dismiss(animated: false)
        }
    }
    
    open func getCroppedImage(newImage:UIImage)->UIImage{
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.width * 3.0 / 4.0))
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
    
    func addUI(){
        view.backgroundColor=UIColor(white: 0, alpha: 0.6)
        
        let loadingImage=UIImageView()
        view.addSubview(loadingImage)
        addConstraints(currentView: loadingImage, MainView: view, centerX: true, centerXValue: 0, centerY: true, centerYValue: 0, top: false, topValue: 0, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: 100, height: true, heightValue: 100)
        loadingImage.rotate360Degrees(duration: 2)
        loadingImage.image = UIImage(named: "ic_picker_loading")
        
        let uploadingImage=UIImageView()
        view.addSubview(uploadingImage)
        addConstraints(currentView: uploadingImage, MainView: view, centerX: true, centerXValue: 0, centerY: true, centerYValue: 0, top: false, topValue: 0, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: 48, height: true, heightValue: 48)
        uploadingImage.image = UIImage(named: "ic_picker_uploading")
        
    }
}
