//
//  ChangePwViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 15..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class ChangePwViewController: UIViewController, UITextFieldDelegate {
    
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    var backBtn : UIButton!
    var mainLabel : UILabel!
    var oriPassword : UITextField!
    var newPassword : UITextField!
    var reEnterPassword : UITextField!
    
    var checkBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        viewSetUp()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        mainLabel = UILabel(frame: CGRect(x: 134*widthRatio, y: 90*heightRatio, width: 126*widthRatio, height: 22*heightRatio))
        mainLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        mainLabel.textAlignment = .center
        mainLabel.text = "비밀번호 변경"
        self.view.addSubview(mainLabel)
        
        //gotoleft
        backBtn = UIButton(frame: CGRect(x: 30*widthRatio, y: 87*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        backBtn.setImage(UIImage(named: "gotoleft"), for: .normal)
        backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backBtn.sizeToFit()
        self.view.addSubview(backBtn)
        
        oriPassword = UITextField(frame: CGRect(x: 36*widthRatio, y: 229*heightRatio, width: 337*widthRatio, height: 13*heightRatio))
        oriPassword.placeholder = "기존 비밀번호를 입력해 주세요"
        oriPassword.font = UIFont.systemFont(ofSize: 12*widthRatio)
        oriPassword.autocorrectionType = UITextAutocorrectionType.no
        oriPassword.keyboardType = UIKeyboardType.default
        oriPassword.returnKeyType = UIReturnKeyType.done
        oriPassword.delegate = self
        
        self.view.addSubview(oriPassword)

        drawLine(startX: 35, startY: 246, width: 305, height: 1, border: false, color: UIColor.black)

        
        newPassword = UITextField(frame: CGRect(x: 36*widthRatio, y: 315*heightRatio, width: 337*widthRatio, height: 13*heightRatio))
        newPassword.placeholder = "새로운 비밀번호를 입력해 주세요"
        newPassword.font = UIFont.systemFont(ofSize: 12*widthRatio)
        newPassword.autocorrectionType = UITextAutocorrectionType.no
        newPassword.keyboardType = UIKeyboardType.default
        newPassword.returnKeyType = UIReturnKeyType.done
        newPassword.delegate = self
        
        self.view.addSubview(newPassword)
        
        drawLine(startX: 35, startY: 332, width: 305, height: 1, border: false, color: UIColor.black)

        reEnterPassword = UITextField(frame: CGRect(x: 36*widthRatio, y: 361*heightRatio, width: 337*widthRatio, height: 13*heightRatio))
        reEnterPassword.placeholder = "새로운 비밀번호 확인"
        reEnterPassword.font = UIFont.systemFont(ofSize: 12*widthRatio)
        reEnterPassword.autocorrectionType = UITextAutocorrectionType.no
        reEnterPassword.keyboardType = UIKeyboardType.default
        reEnterPassword.returnKeyType = UIReturnKeyType.done
        reEnterPassword.delegate = self
        
        self.view.addSubview(reEnterPassword)
        
        drawLine(startX: 35, startY: 378, width: 305, height: 1, border: false, color: UIColor.black)
        
        let checkBtn = UIButton(frame: CGRect(x: 35*widthRatio , y: 422*heightRatio, width: 305*widthRatio, height: 41*heightRatio))
        checkBtn.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        checkBtn.setImage(UIImage(named:"check"), for: .normal)
        self.view.addSubview(checkBtn)
        
        
    }
    
    func backButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkButtonAction(){
        
    }
    
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool, color: UIColor){
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = color
        
        self.view.addSubview(line)
    }
    
    func textField(_ textField: UITextField, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textField.resignFirstResponder()
        }
        return true
    }
    


    

}
