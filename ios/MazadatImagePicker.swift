import UIKit
@objc(MazadatImagePicker)
class MazadatImagePicker: NSObject {

    @objc
    func openCamera(_ length:Int, lang: String, resolve : @escaping  RCTPromiseResolveBlock,reject : @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async{
            let controller = CameraController()
            UIView.appearance().semanticContentAttribute = lang != "ar" ? .forceLeftToRight : .forceRightToLeft
            controller.setData(length: length, lang: lang)
            controller.setPromise(promise: resolve)
            controller.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(controller, animated: true, completion: nil)
        }
      
    }
    
    @objc
    func editPhoto(_ path:String,selectedIndex: Int, lang: String, resolve : @escaping  RCTPromiseResolveBlock,reject : @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async{
            let controller = CameraController()
            UIView.appearance().semanticContentAttribute = lang != "ar" ? .forceLeftToRight : .forceRightToLeft
            controller.setData(path: path.components(separatedBy: ","),selectedIndex: selectedIndex, lang: lang)
            controller.setPromise(promise: resolve)
            controller.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(controller, animated: true, completion: nil)
        }
      
    }
    
    @objc
    func openIdVerification(_ lang: String, resolve : @escaping  RCTPromiseResolveBlock,reject : @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async{
            let controller = CameraController()
            UIView.appearance().semanticContentAttribute = lang != "ar" ? .forceLeftToRight : .forceRightToLeft
            controller.setData(length: 2, lang: lang)
            controller.setPromise(promise: resolve)
            controller.setIsIdVerification(isIdVerification: true)
            controller.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(controller, animated: true, completion: nil)
        }
      
    }
}
