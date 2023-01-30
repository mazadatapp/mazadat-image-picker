//
//  DeleteDialog.swift
//  MazadatImagePicker
//
//  Created by Karim Saad on 29/01/2023.
//  Copyright © 2023 Facebook. All rights reserved.
//

import UIKit

class DeleteDialog: UIViewController {
    var controller:CameraController!
    var lang:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(white: 0, alpha: 0.5)
        
        let frame = UIView()
        view.addSubview(frame)
        addConstraints(currentView: frame, MainView: view, centerX: false, centerXValue: 0, centerY: true, centerYValue: 0, top: false, topValue: 0, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: true, heightValue: 154)
        frame.cornerRadius=20
        frame.backgroundColor = .white
        frame.clipsToBounds = true
        
        let warningImage=UIImageView(image: UIImage(named: "ic_warning"))
        addConstraints(currentView: warningImage, MainView: frame, centerX: true, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 24, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 246)
        
        let titleL=UILabel()
        titleL.text = lang == "en" ? "Are you sure to delete?" : "تأكيد المسح؟"
        titleL.numberOfLines=0
        titleL.textColor = UIColor.white
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "Montserrat-Bold", size: 18)
        frame.addSubview(titleL)
        addConstraints(currentView: titleL, MainView: frame, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 100, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: false, heightValue: 0)
        
        let cancelBtn=UIButton()
        frame.addSubview(cancelBtn)
        cancelBtn.setTitle(lang == "en" ? "Cancel" : "إلغاء", for: .normal)
        cancelBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        cancelBtn.backgroundColor = Colors.tealishColor()
        addConstraints(currentView: cancelBtn, MainView: frame, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: 0, leading: true, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: frame.frame.width*0.5, height: true, heightValue: 40)
        
        let deleteBtn=UIButton()
        frame.addSubview(deleteBtn)
        cancelBtn.setTitle(lang == "en" ? "Yes, Delete" : "نعم، إمسح", for: .normal)
        cancelBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        cancelBtn.backgroundColor = Colors.blueColor()
        addConstraints(currentView: cancelBtn, MainView: frame, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: 0, width: true, widthValue: frame.frame.width*0.5, height: true, heightValue: 40)
        // Do any additional setup after loading the view.
    }
    
    func setData(controller:CameraController,lang:String){
        self.controller = controller
        self.lang = lang
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
