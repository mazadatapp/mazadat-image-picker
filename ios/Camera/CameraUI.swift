//
//  CameraUI.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 29/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import UIKit
extension CameraController{
    func drawUI(){
        let viewWidth=view.frame.width
        let viewHeight=view.frame.height
        let statusBarHeight=getStatusBarHeight()
        let cameraOvelay=CameraOverlay(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(cameraOvelay)
        
        //flash button
        
        flashBtn.setImage(UIImage(named: "ic_picker_flash_off"), for: .normal)
        view.addSubview(flashBtn)
        addConstraints(currentView: flashBtn, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.06*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        //close button
        
        view.addSubview(closeBtn)
        closeBtn.setImage(UIImage(named: "ic_picker_close"), for: .normal)
        addConstraints(currentView: closeBtn, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.06*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: false, heightValue: 0)
        
        //gallery button
        
        galleryBtn.setImage(UIImage(named: "ic_picker_gallery"), for: .normal)
        galleryBtn.setTitle(lang == "en" ? "Gallery" : "المكتبة", for: .normal)
        galleryBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        galleryBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        view.addSubview(galleryBtn)
        addConstraints(currentView: galleryBtn, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.06*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: -60, width: false, widthValue: 0, height: false, heightValue: 0)
        
        
        //camera hint label
        
        cameraHintL.text = lang == "en" ? "Please, Show your product inside the below box. Be sure your photo be clear to get best results" : "من فضلك ، اعرض المنتج الخاص بك داخل المربع أدناه. تأكد من أن صورتك واضحة للحصول على أفضل النتائج"
        cameraHintL.numberOfLines=0
        cameraHintL.textColor = UIColor.white
        cameraHintL.textAlignment = .center
        cameraHintL.font = UIFont(name: "Montserrat-Regular", size: 12)
        view.addSubview(cameraHintL)
        addConstraints(currentView: cameraHintL, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.135*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: false, heightValue: 0)
        
        //capture button
        view.addSubview(captureBtn)
        captureBtn.setImage(UIImage(named: "ic_picker_capture_photo"), for: .normal)
        addConstraints(currentView: captureBtn, MainView: view, centerX: true, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.53*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        //confirm button
        view.addSubview(confirmBtn)
        confirmBtn.setImage(UIImage(named: "ic_picker_confirm"), for: .normal)
        addConstraints(currentView: confirmBtn, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.55*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 32, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        confirmBtn.isHidden=true
        
        //decline button
        view.addSubview(declineBtn)
        declineBtn.setImage(UIImage(named: "ic_picker_decline"), for: .normal)
        addConstraints(currentView: declineBtn, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.55*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: -32, width: false, widthValue: 0, height: false, heightValue: 0)
        declineBtn.isHidden=true
        
        //collection view
        imagesCollection.dataSource=self
        imagesCollection.delegate=self
        imagesCollection.backgroundColor=UIColor.clear
        imagesCollection.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 109,height: 76)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        imagesCollection.collectionViewLayout = layout
        imagesCollection.isScrollEnabled=true
        view.addSubview(imagesCollection)
        addConstraints(currentView: imagesCollection, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.65*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 8, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: true, heightValue: 76)
        
        //max number of images
        maxNoOfImagesL.text = (lang == "en" ? "The maximum number of selected photos is " : "الحد الأقصى لعدد الصور المختارة هو") + String(maxImagesSize)
        maxNoOfImagesL.numberOfLines=0
        maxNoOfImagesL.textColor = UIColor.white
        maxNoOfImagesL.font = UIFont(name: "Montserrat-Regular", size: 12)
        view.addSubview(maxNoOfImagesL)
        addConstraints(currentView: maxNoOfImagesL, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.75*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        
        //done button
        
        view.addSubview(doneBtn)
        doneBtn.setTitle(lang == "en" ? "Done" : "تم", for: .normal)
        doneBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        doneBtn.backgroundColor = Colors.blueColor()
        doneBtn.cornerRadius=15
        addConstraints(currentView: doneBtn, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.91*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: -16, width: true, widthValue: 110, height: true, heightValue: 40)
        
        //crop button
        
        cropBtn.setImage(UIImage(named: "ic_picker_crop")?.maskWithColor(color: UIColor.white), for: .normal)
        cropBtn.setTitle(lang == "en" ? "Crop" : "قص", for: .normal)
        cropBtn.titleLabel!.font = UIFont(name: "Montserrat-Medium", size: 11)
        cropBtn.sizeToFit()
        view.addSubview(cropBtn)
        addConstraints(currentView: cropBtn, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.88*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: true, heightValue: 80)
        cropBtn.centerVertically(padding: 6, lang: lang)
        cropBtn.alpha = 0.38
        
        //crop button
        rotateBtn.setImage(UIImage(named: "ic_picker_rotate")?.maskWithColor(color: UIColor.white), for: .normal)
        rotateBtn.setTitle(lang == "en" ? "Rotate" : "لف", for: .normal)
        rotateBtn.titleLabel!.font = UIFont(name: "Montserrat-Medium", size: 11)
        rotateBtn.sizeToFit()
        view.addSubview(rotateBtn)
        addConstraints(currentView: rotateBtn, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.88*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 76, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: true, heightValue: 80)
        rotateBtn.centerVertically(padding: 6, lang: lang)
        rotateBtn.alpha = 0.38
        
        //delete button
        deleteBtn.setImage(UIImage(named: "ic_picker_trash")?.maskWithColor(color: UIColor.white), for: .normal)
        deleteBtn.setTitle(lang == "en" ? "Delete" : "مسح", for: .normal)
        deleteBtn.titleLabel!.font = UIFont(name: "Montserrat-Medium", size: 11)
        //deleteBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 27, bottom: 38, right: 4)
        view.addSubview(deleteBtn)
        addConstraints(currentView: deleteBtn, MainView: view, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.88*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 146, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: true, heightValue: 80)
        deleteBtn.sizeToFit()
        deleteBtn.centerVertically(padding: 6, lang: lang)
        deleteBtn.alpha = 0.38
        
        view.addSubview(editView)
        editView.backgroundColor = .black
        addConstraints(currentView: editView, MainView: view, centerX: true, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.2*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: 0.91*viewWidth, height: true, heightValue: 0.91*viewWidth * aspectRatioY / aspectRatioX)
        
        editView.addSubview(editImage)
        editImage.contentMode = .scaleAspectFit
        addConstraints(currentView: editImage, MainView: editView, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0, bottom: true, bottomValue: 0, leading: true, leadingValue: 0, trailing: true, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        editView.addSubview(imageCropper)
        addConstraints(currentView: imageCropper, MainView: editView, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0, bottom: true, bottomValue: 0, leading: true, leadingValue: 0, trailing: true, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        editView.isHidden=true
        imageCropper.isHidden=true
        
        if(editPhotoPath != nil){
            imageItems[0].image = UIImage(contentsOfFile: editPhotoPath!)
            print(editPhotoPath)
            itemSelected(index: 0)
            galleryBtn.isHidden=true
            imagesCollection.isHidden=true
            cameraHintL.isHidden=true
            maxNoOfImagesL.isHidden=true
            captureBtn.isHidden=true
            flashBtn.isHidden=true
            deleteBtn.isHidden=true
        }
        
        galleryBtn.addTarget(self, action: #selector(openGallery(_:)), for: .touchUpInside)
        cropBtn.addTarget(self, action: #selector(cropPressed(_:)), for: .touchUpInside)
        rotateBtn.addTarget(self, action: #selector(rotatePressed(_:)), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deletePressed(_:)), for: .touchUpInside)
        
        confirmBtn.addTarget(self, action: #selector(confirmPressed(_:)), for: .touchUpInside)
        declineBtn.addTarget(self, action: #selector(declinePressed(_:)), for: .touchUpInside)
        
        closeBtn.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)
        doneBtn.addTarget(self, action: #selector(donePressed(_:)), for: .touchUpInside)
    }
    
    @objc func openGallery(_ sender: AnyObject) {
        let controller=GalleryController()
        controller.setCameraController(cameraController: self)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
    
    @objc func cropPressed(_ sender: AnyObject) {
        if((editMode || editPhotoPath != nil) && editModeType == EditModeTypes.NOTHING){
            editModeType = EditModeTypes.CROP
            let blueCropImage=UIImage(named: "ic_picker_crop")?.maskWithColor(color: Colors.blueColor())
            cropBtn.setImage(blueCropImage, for: .normal)
            
            confirmBtn.alpha=1.0
            declineBtn.isHidden=false
            
            imageCropper.isHidden = false
            imageCropper.setImage(image: imageItems[editSelectedIndex].image)
        }
    }
    
    @objc func rotatePressed(_ sender: AnyObject) {
        if(editMode || editPhotoPath != nil){
            if(editModeType == EditModeTypes.NOTHING){
                editModeType = EditModeTypes.ROTATE
                originalImage = imageItems[editSelectedIndex].image
                
                let blueRotateImage=UIImage(named: "ic_picker_rotate")?.maskWithColor(color: Colors.blueColor())
                rotateBtn.setImage(blueRotateImage, for: .normal)
                
                confirmBtn.alpha=1.0
                declineBtn.isHidden=false
            }
            editImageRotation -= .pi/2
            editImage.image = originalImage.rotate(radians: editImageRotation)
        }
        //editImage.image=imageItems[editSelectedIndex].image
        
    }
    
    @objc func deletePressed(_ sender: AnyObject) {
        if(editMode){
            let deleteController=DeleteDialog()
            deleteController.modalPresentationStyle = .overFullScreen
            deleteController.setData(controller: self, lang: lang)
            present(deleteController, animated: true)
        }
    }
    
    func deleteConfirm(){
        editModeType = EditModeTypes.DELETE
        imageItems.remove(at: editSelectedIndex)
        if(imageTurn == maxImagesSize){
            maxNoOfImagesL.textColor = UIColor.init(white: 1, alpha: 0.74)
            captureBtn.isHidden = false
            imageItems.append(ImageItem())
        }
        imagesCollection.reloadData()
        imageTurn -= 1
        
        if(imageTurn>0){
            doneBtn.setTitle(lang == "en" ? "Done (\(imageTurn))" : "تم (\(imageTurn))", for: .normal)
        }else{
            doneBtn.setTitle(lang == "en" ? "Done" : "تم", for: .normal)
        }
        resetUI()
        editMode=false
    }
    
    @objc func closePressed(_ sender: AnyObject) {
        if((imageItems.count == 1 && imageItems[0].image != nil) || imageItems.count>1){
            let closeController=CloseDialog()
            closeController.modalPresentationStyle = .overFullScreen
            closeController.setData(controller: self, lang: lang)
            present(closeController, animated: true)
        }else{
            dismiss(animated: true)
        }
    }
    
    @objc func donePressed(_ sender: AnyObject) {
        var result = ""
        for item in imageItems{
            if(item.image != nil){
                var path = item.image.saveImage(name: "\(Int(Date().timeIntervalSince1970)).jpg")
                result = result + path.path + ","
            }
        }
        if(result.count>0){
            result = String(result.dropLast(1))
        }
        promise(result)
        dismiss(animated: true)
    }
    
    @objc func confirmPressed(_ sender: AnyObject) {
        if(editMode && editModeType != EditModeTypes.NOTHING){
            if(editModeType==EditModeTypes.CROP){
                let image=imageCropper.getCroppedImage()
                imageItems[editSelectedIndex].image=image
                reloadCell(index: editSelectedIndex)
                imageCropper.isHidden=true
                let whiteCropImage=UIImage(named: "ic_picker_crop")?.maskWithColor(color:.white)
                cropBtn.setImage(whiteCropImage, for: .normal)
            }else if(editModeType==EditModeTypes.ROTATE){
                let image=editView.snapshot(of: editView.bounds)
                imageItems[editSelectedIndex].image=image
                reloadCell(index: editSelectedIndex)
                
                let whiteRotateImage=UIImage(named: "ic_picker_rotate")?.maskWithColor(color:.white)
                rotateBtn.setImage(whiteRotateImage, for: .normal)
            }
            editModeType = EditModeTypes.NOTHING
            declinePressed(nil)
        }
    }
    
    @objc func declinePressed(_ sender: AnyObject?) {
        if(editModeType==EditModeTypes.ROTATE){
            imageItems[editSelectedIndex].image = originalImage
        }
        let whiteCropImage=UIImage(named: "ic_picker_crop")?.maskWithColor(color:.white)
        cropBtn.setImage(whiteCropImage, for: .normal)
        
        let whiteRotateImage=UIImage(named: "ic_picker_rotate")?.maskWithColor(color:.white)
        rotateBtn.setImage(whiteRotateImage, for: .normal)
        
        print(editSelectedIndex)
        imageCropper.isHidden=true
        editImage.image = imageItems[editSelectedIndex].image
        
        confirmBtn.alpha=0.38
        declineBtn.isHidden=true
        
        editModeType = EditModeTypes.NOTHING
        
        editImageRotation = 0
    }
    
    
}
