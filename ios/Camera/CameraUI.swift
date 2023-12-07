//
//  CameraUI.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 29/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import UIKit
extension CameraController:ImageScrollViewDelegate{
    
    func drawUI(){
        
        var statusBarHeight=getStatusBarHeight()
        
        let viewWidth=view.frame.width
        let viewHeight=view.frame.height - statusBarHeight
        
        var bottomArea:CGFloat=0
        print(statusBarHeight)
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            statusBarHeight = window!.safeAreaInsets.top
            bottomArea = window!.safeAreaInsets.bottom - 2
        }
        
        
        
        let statusBarView=UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: statusBarHeight))
        statusBarView.backgroundColor = .white
        view.addSubview(statusBarView)
        
        let UIviews=UIView(frame: CGRect(x: 0, y: statusBarHeight, width: view.frame.width, height: viewHeight))
        if(editPhotoPath != nil){
            UIviews.backgroundColor = .black
        }
        view.addSubview(UIviews)
        
        cameraOverlay=CameraOverlay(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: viewHeight))
        UIviews.addSubview(cameraOverlay)
        
        //flash button
        
        flashBtn.setImage(UIImage(named: "ic_picker_flash_off"), for: .normal)
        UIviews.addSubview(flashBtn)
        addConstraints(currentView: flashBtn, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.06*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        //close button
        
        UIviews.addSubview(closeBtn)
        closeBtn.setImage(UIImage(named: "ic_picker_close"), for: .normal)
        addConstraints(currentView: closeBtn, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.06*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: false, heightValue: 0)
        
        //gallery button
        
        galleryBtn.setImage(UIImage(named: "ic_picker_gallery"), for: .normal)
        galleryBtn.setTitle(lang == "en" ? "Gallery" : "  المكتبة", for: .normal)
        galleryBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        galleryBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        UIviews.addSubview(galleryBtn)
        addConstraints(currentView: galleryBtn, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.05*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: -60, width: true, widthValue: 80, height: true, heightValue: 40)
        
        
        //camera hint label
        
        setCameraHintText()
        
        cameraHintL.numberOfLines=0
        cameraHintL.textColor = UIColor.white
        cameraHintL.textAlignment = .center
        cameraHintL.font = UIFont(name: "Montserrat-Regular", size: 12)
        UIviews.addSubview(cameraHintL)
        addConstraints(currentView: cameraHintL, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.135*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: false, heightValue: 0)
        
        //capture button
        UIviews.addSubview(captureBtn)
        captureBtn.setImage(UIImage(named: "ic_picker_capture_photo"), for: .normal)
        addConstraints(currentView: captureBtn, MainView: UIviews, centerX: true, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.61*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        //confirm button
        UIviews.addSubview(confirmBtn)
        confirmBtn.setImage(UIImage(named: "ic_picker_confirm"), for: .normal)
        addConstraints(currentView: confirmBtn, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.62*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 32, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        confirmBtn.isHidden=true
        
        //decline button
        UIviews.addSubview(declineBtn)
        declineBtn.setImage(UIImage(named: "ic_picker_decline"), for: .normal)
        addConstraints(currentView: declineBtn, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.62*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: -32, width: false, widthValue: 0, height: false, heightValue: 0)
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
        imagesCollection.showsHorizontalScrollIndicator = false
        imagesCollection.showsVerticalScrollIndicator = false
        UIviews.addSubview(imagesCollection)
        addConstraints(currentView: imagesCollection, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.74*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 8, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: true, heightValue: 76)
        
        //max number of images
        if(!isIdVerification){
            maxNoOfImagesL.text = (lang == "en" ? "The maximum number of selected photos is " : "الحد الأقصى لعدد الصور المختارة هو ") + String(maxImagesSize)
            maxNoOfImagesL.numberOfLines=0
            maxNoOfImagesL.textColor = UIColor.white
            maxNoOfImagesL.font = UIFont(name: "Montserrat-Regular", size: 12)
            UIviews.addSubview(maxNoOfImagesL)
            addConstraints(currentView: maxNoOfImagesL, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.85*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        }
        
        //done button
        
        UIviews.addSubview(doneBtn)
        doneBtn.setTitle(lang == "en" ? "Done (0)" : "(0) تم", for: .normal)
        doneBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        doneBtn.backgroundColor = Colors.blueColor()
        doneBtn.cornerRadius=15
        addConstraints(currentView: doneBtn, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.91*viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: -16, width: true, widthValue: 110, height: true, heightValue: 40)
        
        //crop button
        
        cropBtn.setImage(UIImage(named: "ic_picker_crop")?.maskWithColor(color: UIColor.white), for: .normal)
        cropBtn.setTitle(lang == "en" ? "Crop" : "قص", for: .normal)
        cropBtn.titleLabel!.font = UIFont(name: "Montserrat-Medium", size: 11)
        cropBtn.sizeToFit()
        UIviews.addSubview(cropBtn)
        addConstraints(currentView: cropBtn, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.88*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: true, heightValue: 80)
        cropBtn.centerVertically(padding: 6, lang: lang)
        cropBtn.alpha = 0.38
        
        //crop button
        rotateBtn.setImage(UIImage(named: "ic_picker_rotate")?.maskWithColor(color: UIColor.white), for: .normal)
        rotateBtn.setTitle(lang == "en" ? "Rotate" : "استدارة", for: .normal)
        rotateBtn.titleLabel!.font = UIFont(name: "Montserrat-Medium", size: 11)
        rotateBtn.sizeToFit()
        UIviews.addSubview(rotateBtn)
        addConstraints(currentView: rotateBtn, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.88*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 76, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: true, heightValue: 80)
        rotateBtn.centerVertically(padding: 6, lang: lang)
        rotateBtn.alpha = 0.38
        
        //delete button
        deleteBtn.setImage(UIImage(named: "ic_picker_trash")?.maskWithColor(color: UIColor.white), for: .normal)
        deleteBtn.setTitle(lang == "en" ? "Delete" : "مسح", for: .normal)
        deleteBtn.titleLabel!.font = UIFont(name: "Montserrat-Medium", size: 11)
        //deleteBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 27, bottom: 38, right: 4)
        UIviews.addSubview(deleteBtn)
        addConstraints(currentView: deleteBtn, MainView: UIviews, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.88*viewHeight, bottom: false, bottomValue: 0, leading: true, leadingValue: 146, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: true, heightValue: 80)
        deleteBtn.sizeToFit()
        deleteBtn.centerVertically(padding: 6, lang: lang)
        deleteBtn.alpha = 0.38
        
        
        UIviews.addSubview(editView)
        editView.backgroundColor = .black
        editView.clipsToBounds = true
        let editViewHeight = 0.91*viewWidth * aspectRatioY / aspectRatioX
        let editViewWidth = 0.91*viewWidth
        
        addConstraints(currentView: editView, MainView: UIviews, centerX: true, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0.2 * viewHeight, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: 0.91*viewWidth, height: true, heightValue: 0.91*viewWidth * aspectRatioY / aspectRatioX)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {[self] in
            addCorners(cameraView: editView.frame, parent: UIviews)
        })
        
        
        editView.addSubview(editImage)
        editImage.contentMode = .scaleAspectFit
        addConstraints(currentView: editImage, MainView: editView, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0, bottom: true, bottomValue: 0, leading: true, leadingValue: 0, trailing: true, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        editView.addSubview(imageCropper)
        imageCropper.imageScrollViewDelegate=self
        addConstraints(currentView: imageCropper, MainView: editView, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 0, bottom: true, bottomValue: 0, leading: true, leadingValue: 0, trailing: true, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        editView.addSubview(indicator)
        addConstraints(currentView: indicator, MainView: editView, centerX: true, centerXValue: 0, centerY: true, centerYValue: 0, top: false, topValue: 0, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        indicator.color = Colors.blueColor()
        indicator.startAnimating()
        if #available(iOS 13.0, *) {
            indicator.style = .large
        }else{
            indicator.style = .whiteLarge
        }
        

        
        editView.isHidden=true
        imageCropper.isHidden=true
        indicator.isHidden=true
        
        gridVertical1=UIView()
        gridVertical1.backgroundColor = Colors.blueColor();
        
        gridVertical2=UIView()
        gridVertical2.backgroundColor = Colors.blueColor();
        
        gridHorizontal1 = UIView()
        gridHorizontal1.backgroundColor = Colors.blueColor();
        
        gridHorizontal2 = UIView()
        gridHorizontal2.backgroundColor = Colors.blueColor();
        
        gridVertical1.frame = CGRect(x: (editViewWidth * 0.33) - 0.5, y: 0, width: 1, height: editViewHeight)
        gridVertical2.frame = CGRect(x: (editViewWidth * 0.66) - 0.5, y: 0, width: 1, height: editViewHeight)
        gridHorizontal1.frame = CGRect(x: 0, y: (editViewHeight * 0.33) - 0.5, width: editViewWidth, height: 1)
        gridHorizontal2.frame = CGRect(x: 0, y: (editViewHeight * 0.66) - 0.5, width: editViewWidth, height: 1)
        
        gridVertical1.isHidden = true
        gridVertical2.isHidden = true
        gridHorizontal1.isHidden = true
        gridHorizontal2.isHidden = true
        
        editView.addSubview(gridVertical1)
        editView.addSubview(gridVertical2)
        editView.addSubview(gridHorizontal1)
        editView.addSubview(gridHorizontal2)
        
        if(editPhotoPath != nil){
            if(editPhotoPath.contains("https://") || editPhotoPath.contains("http://")){
                showPreviewLayer(flag: false)
                editView.isHidden=false
                doneBtn.backgroundColor = Colors.white38Color()
                doneBtn.setTitleColor(Colors.black26Color(), for: .normal)
                canPressDone = false
                indicator.isHidden=false
                downloadImage(url: editPhotoPath)
            }else{
                imageItems[0].image = UIImage(contentsOfFile: editPhotoPath!)
                itemSelected(index: 0)
                doneBtn.backgroundColor = Colors.blueColor()
                canPressDone = true
            }
            
            galleryBtn.isHidden=true
            imagesCollection.isHidden=true
            cameraHintL.isHidden=true
            maxNoOfImagesL.isHidden=true
            captureBtn.isHidden=true
            flashBtn.isHidden=true
            deleteBtn.isHidden=true
            
            doneBtn.setTitle(lang == "en" ? "Done (1)" : "(1) تم", for: .normal)
            
        }else{
            checkDoneButton()
        }
        
        galleryBtn.addTarget(self, action: #selector(openGallery(_:)), for: .touchUpInside)
        captureBtn.addTarget(self, action: #selector(capturePressed(_:)), for: .touchUpInside)
        cropBtn.addTarget(self, action: #selector(cropPressed(_:)), for: .touchUpInside)
        rotateBtn.addTarget(self, action: #selector(rotatePressed(_:)), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deletePressed(_:)), for: .touchUpInside)
        
        confirmBtn.addTarget(self, action: #selector(confirmPressed(_:)), for: .touchUpInside)
        declineBtn.addTarget(self, action: #selector(declinePressed(_:)), for: .touchUpInside)
        
        closeBtn.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)
        doneBtn.addTarget(self, action: #selector(donePressed(_:)), for: .touchUpInside)
        
        flashBtn.addTarget(self, action: #selector(flashPressed(_:)), for: .touchUpInside)
    }
    func downloadImage(url: String) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest, completionHandler: { [self] data,_,_ in
            DispatchQueue.main.async { [self] in
                imageItems[0].image = UIImage(data: data!)
                itemSelected(index: 0)
                doneBtn.backgroundColor = Colors.blueColor()
                doneBtn.setTitleColor(Colors.whiteColor(), for: .normal)
                canPressDone = true
                indicator.isHidden=true
            }
            
        })
        task.resume()
    }
    
    @objc func openGallery(_ sender: AnyObject) {
        if(imageTurn==maxImagesSize || editMode){
            return
        }
        
        if #available(iOS 14.0, *) {
            let controller=GallerMultiSelectController()
            controller.setCameraController(cameraController: self, maxImages: maxImagesSize - imageItems.count)
            controller.modalPresentationStyle = .overFullScreen
            present(controller, animated: true)
        } else {
            let controller=GalleryController()
            controller.setCameraController(cameraController: self)
            controller.modalPresentationStyle = .overFullScreen
            present(controller, animated: true)
        }
        
        
        
    }
    
    @objc func capturePressed(_ sender: AnyObject) {
        cameraOverlay.animateCameraFlickerView()
        takePhoto()
    }
    
    @objc func flashPressed(_ sender: AnyObject) {
        isFlashOn = !isFlashOn
        flashMode = isFlashOn ? .on : .off
        flashBtn.setImage(isFlashOn ? UIImage(named: "ic_picker_flash_on") : UIImage(named: "ic_picker_flash_off"), for: .normal)
    }
    
    @objc func cropPressed(_ sender: AnyObject) {
        if((editMode || editPhotoPath != nil) && editModeType == EditModeTypes.NOTHING){
            scrollingBegin = false
            
            setCameraHintText()
            let blueCropImage=UIImage(named: "ic_picker_crop")?.maskWithColor(color: Colors.blueColor())
            cropBtn.setImage(blueCropImage, for: .normal)
            
            confirmBtn.isHidden=false
            declineBtn.isHidden=false
            
            confirmBtn.alpha = 0.5
            declineBtn.alpha = 0.5
            
            confirmBtn.isEnabled = false
            declineBtn.isEnabled = false
            
            imageCropper.isHidden = false
            imageCropper.display(image: imageItems[editSelectedIndex].image)
            editImage.isHidden=true
            
            gridVertical1.isHidden = false
            gridVertical2.isHidden = false
            gridHorizontal1.isHidden = false
            gridHorizontal2.isHidden = false
        }
    }
    
    @objc func rotatePressed(_ sender: AnyObject) {
        if(editMode && (editModeType == EditModeTypes.NOTHING || !scrollingBegin)){
            if(!scrollingBegin){
                cancelCrop()
            }
            disableDoneBtn()
            editModeType = EditModeTypes.ROTATE
            setCameraHintText()
            originalImage = imageItems[editSelectedIndex].image
            let blueRotateImage=UIImage(named: "ic_picker_rotate")?.maskWithColor(color: Colors.blueColor())
            rotateBtn.setImage(blueRotateImage, for: .normal)
            
            confirmBtn.isHidden=false
            declineBtn.isHidden=false
            
            editImageRotation -= .pi/2
            editImage.image = originalImage.rotate(radians: editImageRotation)
        }else if(editModeType == EditModeTypes.ROTATE){
            disableDoneBtn()
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
    
    func setCameraHintText(){
        //TODO
        if(editModeType == EditModeTypes.CROP){
            cameraHintL.text = lang == "en" ? "Use 2 fingners to zoom." : "استخدم إصبعين لتقريب الصورة."
        }else if(editModeType == EditModeTypes.ROTATE){
            cameraHintL.text = lang == "en" ? "Keep pressing to rotate the image" : "واصل الضغط للف الصورة"
        }else{
            if(isIdVerification){
                cameraHintL.text = lang == "en" ? "Capture the front and back of the ID\nEnsure that all the data is visible and clear" : "قم بتصوير البطاقة الخاصة بك من الأمام و الخلف\nتأكد من أن جميع البيانات الخاصة بك مرئية و واضحة"
            }else{
                cameraHintL.text = lang == "en" ? "Please make sure your item is visible with good lighting conditions in the box below." : "اعرض .المنتج الخاص بك داخل المربع أدناه. تأكد من أن صورتك واضحة للحصول على أفضل النتائج"
            }
        }
    }
    
    func checkDoneButton(){
        doneBtn.backgroundColor = imageTurn == 0 ? Colors.white38Color() : Colors.blueColor()
        doneBtn.setTitleColor(imageTurn == 0 ? Colors.black26Color() : Colors.whiteColor(), for: .normal)
        
        canPressDone = imageTurn>0
    }
    
    func disableDoneBtn(){
        doneBtn.backgroundColor = Colors.white38Color()
        doneBtn.setTitleColor(Colors.black26Color(), for: .normal)
        canPressDone = false
    }
    
    func enableDoneBtn(){
        doneBtn.backgroundColor = Colors.blueColor()
        doneBtn.setTitleColor(Colors.whiteColor(), for: .normal)
        canPressDone = true
    }
    
    func addCorners(cameraView:CGRect,parent:UIView){
        let topTopLeftLine = UIView(frame: CGRect(x: cameraView.minX, y: cameraView.minY - 2, width: 30, height: 2))
        topTopLeftLine.backgroundColor = Colors.blueColor()
        parent.addSubview(topTopLeftLine)
        
        let topLeftLine = UIView(frame: CGRect(x: cameraView.minX - 1 ,y: cameraView.minY - 2, width: 2, height: 30))
        topLeftLine.backgroundColor = Colors.blueColor()
        parent.addSubview(topLeftLine)
        
        let topTopRightLine = UIView(frame: CGRect(x: cameraView.maxX - 30, y: cameraView.minY - 2, width: 30, height: 2))
        topTopRightLine.backgroundColor = Colors.blueColor()
        parent.addSubview(topTopRightLine)
        
        let topRightLine = UIView(frame: CGRect(x: cameraView.maxX ,y: cameraView.minY - 2, width: 2, height: 30))
        topRightLine.backgroundColor = Colors.blueColor()
        parent.addSubview(topRightLine)
        
        let bottomBottomLeftLine = UIView(frame: CGRect(x: cameraView.minX, y: cameraView.maxY , width: 30, height: 2))
        bottomBottomLeftLine.backgroundColor = Colors.blueColor()
        parent.addSubview(bottomBottomLeftLine)
        
        let bottomLeftLine = UIView(frame: CGRect(x: cameraView.minX - 1 ,y: cameraView.maxY - 30, width: 2, height: 32))
        bottomLeftLine.backgroundColor = Colors.blueColor()
        parent.addSubview(bottomLeftLine)
        
        let bottomBottomRightLine = UIView(frame: CGRect(x: cameraView.maxX - 30, y: cameraView.maxY , width: 30, height: 2))
        bottomBottomRightLine.backgroundColor = Colors.blueColor()
        parent.addSubview(bottomBottomRightLine)
        
        let bottomRightLine = UIView(frame: CGRect(x: cameraView.maxX ,y: cameraView.maxY - 30, width: 2, height: 32))
        bottomRightLine.backgroundColor = Colors.blueColor()
        parent.addSubview(bottomRightLine)
    }
    
    func deleteConfirm(){
        editModeType = EditModeTypes.DELETE
        imageItems.remove(at: editSelectedIndex)
        if(imageTurn == maxImagesSize){
            maxNoOfImagesL.textColor = UIColor.init(white: 1, alpha: 0.74)
            imageItems.append(ImageItem())
            captureBtn.alpha=1.0
            captureBtn.isEnabled=true
        }
        selectedPosition = imageItems.count - 1
        imagesCollection.reloadData()
        scrollToCell(index: selectedPosition - 1)
        imageTurn -= 1
        
        
        if(imageTurn>0){
            doneBtn.setTitle(lang == "en" ? "Done (\(imageTurn))" : "تم (\(imageTurn))", for: .normal)
        }else{
            doneBtn.setTitle(lang == "en" ? "Done" : "تم", for: .normal)
        }
        resetUI()
        editMode=false
        checkDoneButton()
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
        
        if(!canPressDone){
            return
        }
        
        if(isIdVerification){
            if(imageItems[0].image == nil){
                showToast(message: lang == "en" ? "Please add the front ID image" : "برجاء إضافة الوجه الأمامى")
                return
            }else if(imageItems[1].image == nil){
                showToast(message: lang == "en" ? "Please add the back ID image" : "برجاء إضافة الوجه الخلفى")
                return
            }
        }
        var result = ""
        for item in imageItems{
            if(item.image != nil){
                let uuid = UUID().uuidString
                let path = item.image.saveImage(name: "\(uuid).jpg")
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
                
                gridVertical1.isHidden = true
                gridVertical2.isHidden = true
                gridHorizontal1.isHidden = true
                gridHorizontal2.isHidden = true
                
                let image=editView.snapshot(of: editView.bounds)
                imageItems[editSelectedIndex].image=image
                reloadCell(index: editSelectedIndex)
                imageCropper.isHidden=true
                editImage.isHidden=false
                let whiteCropImage=UIImage(named: "ic_picker_crop")?.maskWithColor(color:.white)
                cropBtn.setImage(whiteCropImage, for: .normal)
            }else if(editModeType==EditModeTypes.ROTATE){
                let image=editView.snapshot(of: editView.bounds)
                imageItems[editSelectedIndex].image=image
                reloadCell(index: editSelectedIndex)
                
                let whiteRotateImage=UIImage(named: "ic_picker_rotate")?.maskWithColor(color:.white)
                rotateBtn.setImage(whiteRotateImage, for: .normal)
            }
        }
        
        declinePressed(nil)
    }
    
    @objc func declinePressed(_ sender: AnyObject?) {
        if(editModeType==EditModeTypes.ROTATE && sender != nil){
            imageItems[editSelectedIndex].image = originalImage
        }
        let whiteCropImage=UIImage(named: "ic_picker_crop")?.maskWithColor(color:.white)
        cropBtn.setImage(whiteCropImage, for: .normal)
        
        let whiteRotateImage=UIImage(named: "ic_picker_rotate")?.maskWithColor(color:.white)
        rotateBtn.setImage(whiteRotateImage, for: .normal)
        
        
        imageCropper.isHidden=true
        editImage.isHidden=false
        editImage.image = imageItems[editSelectedIndex].image
        
        confirmBtn.isHidden=true
        declineBtn.isHidden=true
        
        confirmBtn.alpha = 1.0
        declineBtn.alpha = 1.0
        
        confirmBtn.isEnabled = true
        declineBtn.isEnabled = true
        
        editModeType = EditModeTypes.NOTHING
        
        editImageRotation = 0
        
        gridVertical1.isHidden = true
        gridVertical2.isHidden = true
        gridHorizontal1.isHidden = true
        gridHorizontal2.isHidden = true
        
        setCameraHintText()
        enableDoneBtn()
    }
    
    func cancelCrop() {
        let whiteCropImage=UIImage(named: "ic_picker_crop")?.maskWithColor(color:.white)
        cropBtn.setImage(whiteCropImage, for: .normal)
        
        imageCropper.isHidden=true
        editImage.isHidden=false
        confirmBtn.isHidden=true
        declineBtn.isHidden=true
        
        confirmBtn.alpha = 1.0
        declineBtn.alpha = 1.0
        
        confirmBtn.isEnabled = true
        declineBtn.isEnabled = true
        
        gridVertical1.isHidden = true
        gridVertical2.isHidden = true
        gridHorizontal1.isHidden = true
        gridHorizontal2.isHidden = true
    }
    
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
    
    }
    
    func zoomBegin() {
        confirmBtn.alpha = 1.0
        declineBtn.alpha = 1.0
        
        confirmBtn.isEnabled = true
        declineBtn.isEnabled = true
        
        scrollingBegin = true
        
        disableDoneBtn()
        editModeType = EditModeTypes.CROP
    }
    
}
