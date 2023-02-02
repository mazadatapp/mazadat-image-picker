//
//  CameraController.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 29/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import UIKit

class CameraController: SwiftyCamViewController,SwiftyCamViewControllerDelegate {
    var promise:RCTPromiseResolveBlock!
    var lang:String!
    var maxImagesSize=0
    
    let flashBtn=UIButton()
    let closeBtn=UIButton()
    let galleryBtn=UIButton()
    let cameraHintL=UILabel()
    let captureBtn=UIButton()
    let confirmBtn=UIButton()
    let declineBtn=UIButton()
    let imagesCollection=UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let maxNoOfImagesL=UILabel()
    let doneBtn=UIButton()
    let cropBtn=UIButton()
    let rotateBtn=UIButton()
    let deleteBtn=UIButton()
    
    let editView=UIView()
    let editImage=UIImageView()
    let imageCropper=ImageScrollView()
    
    let aspectRatioX=4.0
    let aspectRatioY=3.0
    
    var imageItems=[ImageItem]()
    var imageTurn=0
    
    var editMode=false
    var editModeType=EditModeTypes.NOTHING
    var editSelectedIndex = -1
    var originalImage:UIImage!
    var editImageRotation:Double=0
    var editPhotoPath:String!
    
    var isFlashOn=false
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        imageItems.append(ImageItem())
        drawUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setData(length:Int,lang:String){
        self.lang = lang
        self.maxImagesSize = length
        print(maxImagesSize)
    }
    
    func setData(path:String,lang:String){
        self.lang = lang
        self.editPhotoPath = path
        print(maxImagesSize)
    }
    
    func setPromise(promise:@escaping RCTPromiseResolveBlock){
        self.promise = promise
    }
    
    func getCroppedImage(image:UIImage){
        imageItems[imageTurn].image=image
        reloadCell(index: imageTurn)
        imageTurn += 1
        if(imageTurn==maxImagesSize){
            maxNoOfImagesL.textColor = Colors.redColor()
            captureBtn.alpha=0.38
            captureBtn.isEnabled=false
        }else{
            imageItems.append(ImageItem())
        }
        imagesCollection.reloadData()
        doneBtn.setTitle(lang == "en" ? "Done (\(imageTurn))" : "تم (\(imageTurn))", for: .normal)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        
        print(photo.size.width)
        let width=Double(photo.size.width) * 0.91
        let height=width * CGFloat(aspectRatioY/aspectRatioX)
        let croppedImage=photo.croppedImage(inRect: CGRect(x: Double(photo.size.width/2) - width / 2, y: Double(photo.size.height) * 0.2, width: width, height: height))
        getCroppedImage(image: croppedImage)
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when startVideoRecording() is called
        // Called if a SwiftyCamButton begins a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when stopVideoRecording() is called
        // Called if a SwiftyCamButton ends a long press gesture
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        // Called when stopVideoRecording() is called and the video is finished processing
        // Returns a URL in the temporary directory where video is stored
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        // Called when a user initiates a tap gesture on the preview layer
        // Will only be called if tapToFocus = true
        // Returns a CGPoint of the tap location on the preview layer
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        // Called when a user initiates a pinch gesture on the preview layer
        // Will only be called if pinchToZoomn = true
        // Returns a CGFloat of the current zoom level
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        // Called when user switches between cameras
        // Returns current camera selection
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
