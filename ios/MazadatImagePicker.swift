import UIKit
@objc(MazadatImagePicker)
class MazadatImagePicker: NSObject {

  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }
    
    @objc
    func openCamera(_ length:Int, lang: String, resolve : @escaping  RCTPromiseResolveBlock,reject : @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async{
            let controller = CameraController()
            UIView.appearance().semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
            controller.setData(length: length, lang: lang)
            controller.setPromise(promise: resolve)
            controller.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(controller, animated: true, completion: nil)
        }
      
    }
    
    @objc
    func editPhoto(_ path:String, lang: String, resolve : @escaping  RCTPromiseResolveBlock,reject : @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async{
            let controller = CameraController()
            UIView.appearance().semanticContentAttribute = lang == "en" ? .forceLeftToRight : .forceRightToLeft
            controller.setData(path: path, lang: lang)
            controller.setPromise(promise: resolve)
            controller.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(controller, animated: true, completion: nil)
        }
      
    }
}
