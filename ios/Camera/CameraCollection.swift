//
//  CameraCollection.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 29/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import Foundation
import UIKit
extension CameraController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        cell.editBtn.isHidden = imageItems[indexPath.row].image == nil
        cell.editBtn.isEnabled=false
        cell.editBtn.setTitle(lang == "en" ? "Select to edit" : "إضغط للتعديل", for: .normal)
        cell.editBtn.sizeToFit()
        cell.editBtn.centerVertically(padding: 2, lang: lang)
        if(imageItems[indexPath.row].image != nil){
            cell.image_.image = imageItems[indexPath.row].image
        }else{
            cell.image_.image = nil
        }
        cell.frameBlue.borderWidth = (selectedPosition == indexPath.row) ? 2 : 0
        
        if(isIdVerification){
            if(imageTurn == 0){
                cell.hintL.text = lang == "en" ? "Front ID" : "الوجه الأمامي"
            }else{
                cell.hintL.text = lang == "en" ? "Back ID" : "الوجه الخلفي"
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelected(index: indexPath.row)
        selectedPosition = indexPath.row
        collectionView.reloadData()
    }
    
    func itemSelected(index:Int){
        if(editModeType == EditModeTypes.NOTHING && imageItems[index].image != nil){
            editView.isHidden=false
            editImage.image = imageItems[index].image
            showPreviewLayer(flag: false)
            editMode = true
            
            cropBtn.alpha=1.0
            rotateBtn.alpha=1.0
            deleteBtn.alpha=1.0
            
            galleryBtn.isHidden=true
            flashBtn.isHidden=true
            
            confirmBtn.isHidden = false
            confirmBtn.alpha = 0.38
            captureBtn.isHidden=true
            editSelectedIndex=index
        }else if(editModeType == EditModeTypes.NOTHING){
            resetUI()
            editMode = false
        }
    }
    
    func reloadCell(index:Int){
        imagesCollection.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func resetUI(){
        editMode = false
        editView.isHidden=true
        showPreviewLayer(flag: true)
        cropBtn.alpha=0.38
        rotateBtn.alpha=0.38
        deleteBtn.alpha=0.38
        captureBtn.isHidden=false
        
        confirmBtn.isHidden=true
        declineBtn.isHidden=true
        
        galleryBtn.isHidden=false
        flashBtn.isHidden=false
        
        editModeType = EditModeTypes.NOTHING
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 109, height: 76)
//    }
    
    
    
}
