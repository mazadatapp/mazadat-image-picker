//
//  CloseDialog.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 30/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import UIKit

class CloseDialog: UIViewController {
    
    var controller:CameraController!
    var lang:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(white: 0, alpha: 0.5)
        
        let frame = UIView()
        view.addSubview(frame)
        addConstraints(currentView: frame, MainView: view, centerX: false, centerXValue: 0, centerY: true, centerYValue: 0, top: false, topValue: 0, bottom: false, bottomValue: 0, leading: true, leadingValue: 24, trailing: true, trailingValue: -24, width: false, widthValue: 0, height: true, heightValue: 260)
        frame.cornerRadius=20
        frame.backgroundColor = .white
        frame.clipsToBounds = true
        
        let warningImage=UIImageView(image: UIImage(named: "ic_warning"))
        frame.addSubview(warningImage)
        addConstraints(currentView: warningImage, MainView: frame, centerX: true, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 24, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 246)
        
        let titleL=UILabel()
        titleL.text = lang == "en" ? "Are you sure you want to close?" : "هل أنت متأكد أنك تريد الإغلاق؟"
        titleL.numberOfLines=0
        titleL.textColor = UIColor.black
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "Montserrat-Bold", size: 18)
        frame.addSubview(titleL)
        addConstraints(currentView: titleL, MainView: frame, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 100, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: false, heightValue: 0)
        
        let closeHintL=UILabel()
        closeHintL.text = lang == "en" ? "All modifications made will be discarded!" : "سيتم إلغاء جميع الصور والتعديلات التي قمت بها"
        closeHintL.numberOfLines=0
        closeHintL.textColor = UIColor.init(white: 0, alpha: 0.6)
        closeHintL.textAlignment = .center
        closeHintL.font = UIFont(name: "Montserrat-Medium", size: 14)
        frame.addSubview(closeHintL)
        addConstraints(currentView: closeHintL, MainView: frame, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 150, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: false, heightValue: 0)
        
        
        let frameWidth = view.frame.width - 32
        
        let cancelBtn=UIButton()
        frame.addSubview(cancelBtn)
        cancelBtn.setTitle(lang == "en" ? "Cancel" : "إلغاء", for: .normal)
        cancelBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        cancelBtn.backgroundColor = Colors.tealishColor()
        addConstraints(currentView: cancelBtn, MainView: frame, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: 0, leading: true, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: frameWidth*0.5, height: true, heightValue: 54)
        
        let closeBtn=UIButton()
        frame.addSubview(closeBtn)
        closeBtn.setTitle(lang == "en" ? "Yes, Close" : "تأكيد", for: .normal)
        closeBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        closeBtn.backgroundColor = Colors.blueColor()
        addConstraints(currentView: closeBtn, MainView: frame, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: 0, width: true, widthValue: frameWidth*0.5, height: true, heightValue: 54)
        // Do any additional setup after loading the view.
        
        cancelBtn.addTarget(self, action: #selector(cancelPressed(_:)), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(closePressed(_:)), for: .touchUpInside)
    }
    
    func setData(controller:CameraController,lang:String){
        self.controller = controller
        self.lang = lang
    }
    
    @objc func cancelPressed(_ sender: AnyObject) {
        dismiss(animated: true)
    }
    
    @objc func closePressed(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: { [self] in
            controller.dismiss(animated: true)
        })
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
