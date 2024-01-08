//
//  GalleryController.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 30/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import UIKit

class GalleryController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var cropView:CropperView!
    var cropIm:UIImageView!
    let imagePickerController = UIImagePickerController()
    var list=[UIImage]()
    var cameraController:CameraController!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        cropView = CropperView(frame: CGRect(x: 0, y: getStatusBarHeight(), width: view.frame.width, height: view.frame.height - getStatusBarHeight()))
        view.addSubview(cropView)
        
        cropIm = UIImageView()
        view.addSubview(cropIm)
        cropIm.image = UIImage(named: "ic_picker_crop")
        addConstraints(currentView: cropIm, MainView: view, centerX: true, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: -32, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: 40, height: true, heightValue: 40)
        
        cropIm.isHidden=true
        cropView.isHidden=true
        
        imagePickerController.allowsEditing = false //If you want edit option set "true"
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .overFullScreen
        present(imagePickerController, animated: true, completion: nil)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cropImagePressed(tapGestureRecognizer:)))
        cropIm.isUserInteractionEnabled = true
        cropIm.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    @objc func cropImagePressed(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let image=cropView.getCroppedImage()
        cameraController.getCroppedImage(image: image)
        dismiss(animated: true)
        // Your action
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: {[self] in
            
//            cropView.isHidden = false
//            cropIm.isHidden=false
//            cropView.setImage(image: tempImage)
            addUI()
            var hasError=false
            DispatchQueue.main.async { [self] in
                var image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                var imgData = image.jpegData(compressionQuality: 1)!
                var imageSize: Int = imgData.count
                if(imageSize<=5000000){
                    if(imageSize > 2000000){
                        imgData = image.jpegData(compressionQuality: CGFloat(4000000)/CGFloat(imageSize))!
                        imageSize = imgData.count
                        image = UIImage(data: imgData)!
                    }
                    list.append(getCroppedImage(newImage: image))
                }else{
                    hasError = true
                }
                cameraController.getImagesFromGallery(images: list, hasError: hasError)
                dismiss(animated: false)
            }
            
            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        dismiss(animated: false)
        
    }
    

    
    func setCameraController(cameraController:CameraController){
        self.cameraController=cameraController
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
