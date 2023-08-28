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
        addConstraints(currentView: frame, MainView: view, centerX: false, centerXValue: 0, centerY: true, centerYValue: 0, top: false, topValue: 0, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: true, heightValue: 208)
        frame.cornerRadius=20
        frame.backgroundColor = .white
        frame.clipsToBounds = true
        
        let warningImage=UIImageView(image: UIImage(named: "ic_warning"))
        frame.addSubview(warningImage)
        addConstraints(currentView: warningImage, MainView: frame, centerX: true, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 24, bottom: false, bottomValue: 0, leading: false, leadingValue: 0, trailing: false, trailingValue: 0, width: false, widthValue: 0, height: false, heightValue: 0)
        
        let titleL=UILabel()
        titleL.text = lang == "en" ? "Are you sure you want to delete this?" : "هل انت متأكد من الحذف؟"
        titleL.numberOfLines=0
        titleL.textColor = UIColor.black
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "Montserrat-Bold", size: 18)
        frame.addSubview(titleL)
        addConstraints(currentView: titleL, MainView: frame, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: true, topValue: 100, bottom: false, bottomValue: 0, leading: true, leadingValue: 16, trailing: true, trailingValue: -16, width: false, widthValue: 0, height: false, heightValue: 0)
        
        let frameWidth = view.frame.width - 32
        
        let cancelBtn=UIButton()
        frame.addSubview(cancelBtn)
        cancelBtn.setTitle(lang == "en" ? "Cancel" : "إلغاء", for: .normal)
        cancelBtn.titleLabel?.textColor = UIColor.white
        cancelBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        cancelBtn.backgroundColor = Colors.tealishColor()
        addConstraints(currentView: cancelBtn, MainView: frame, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: 0, leading: true, leadingValue: 0, trailing: false, trailingValue: 0, width: true, widthValue: frameWidth*0.5, height: true, heightValue: 54)
        
        let deleteBtn=UIButton()
        frame.addSubview(deleteBtn)
        deleteBtn.setTitle(lang == "en" ? "Yes, Delete" : "تأكيد", for: .normal)
        deleteBtn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        deleteBtn.backgroundColor = Colors.blueColor()
        addConstraints(currentView: deleteBtn, MainView: frame, centerX: false, centerXValue: 0, centerY: false, centerYValue: 0, top: false, topValue: 0, bottom: true, bottomValue: 0, leading: false, leadingValue: 0, trailing: true, trailingValue: 0, width: true, widthValue: frameWidth*0.5, height: true, heightValue: 54)
        // Do any additional setup after loading the view.
        
        cancelBtn.addTarget(self, action: #selector(cancelPressed(_:)), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deletePressed(_:)), for: .touchUpInside)
    }
    
    func setData(controller:CameraController,lang:String){
        self.controller = controller
        self.lang = lang
    }
    
    @objc func cancelPressed(_ sender: AnyObject) {
        dismiss(animated: true)
    }
    
    @objc func deletePressed(_ sender: AnyObject) {
        controller.deleteConfirm()
        dismiss(animated: true)
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
