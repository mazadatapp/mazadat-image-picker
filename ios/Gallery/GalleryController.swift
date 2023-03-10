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
        
        let tempImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        cropView.isHidden = false
        cropIm.isHidden=false
        cropView.setImage(image: tempImage)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        dismiss(animated: false)
        
    }
    
    func setCameraController(cameraController:CameraController){
        self.cameraController=cameraController
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
