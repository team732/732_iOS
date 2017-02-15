//
//  RegisterEmailViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 15..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class RegisterEmailViewController: UIViewController,UITextFieldDelegate {

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0

    var backBtn : UIButton!
    var mainLabel : UILabel!
    var emailTextField : UITextField!
    var checkEmailLabel : UILabel!
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
        
        mainLabel = UILabel(frame: CGRect(x: 134*widthRatio, y: 90*heightRatio, width: 107*widthRatio, height: 22*heightRatio))
        mainLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        mainLabel.textAlignment = .center
        mainLabel.text = "이메일 등록"
        self.view.addSubview(mainLabel)
        
        //gotoleft
        backBtn = UIButton(frame: CGRect(x: 30*widthRatio, y: 87*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        backBtn.setImage(UIImage(named: "gotoleft"), for: .normal)
        backBtn.addTarget(self, action: #selector(SettingViewController.backButtonAction), for: .touchUpInside)
        backBtn.sizeToFit()
        self.view.addSubview(backBtn)
        
        emailTextField = UITextField(frame: CGRect(x: 36*widthRatio, y: 224*heightRatio, width: 337*widthRatio, height: 13*heightRatio))
        emailTextField.placeholder = "이메일을 입력해 주세요 (아이디,비밀번호 분실시 사용됩니다.)"
        emailTextField.font = UIFont.systemFont(ofSize: 12*widthRatio)
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.keyboardType = UIKeyboardType.default
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.delegate = self
        
        self.view.addSubview(emailTextField)
        
        drawLine(startX: 35, startY: 246, width: 305, height: 1, border: false, color: UIColor.black)
        
        checkEmailLabel = UILabel(frame: CGRect(x: 36*widthRatio, y: 254*heightRatio, width: 179*widthRatio, height: 13*heightRatio))
        checkEmailLabel.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        checkEmailLabel.isHidden = true
        checkEmailLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        self.view.addSubview(checkEmailLabel)
        
        let checkBtn = UIButton(frame: CGRect(x: 35*widthRatio , y: 290*heightRatio, width: 305*widthRatio, height: 41*heightRatio))
        checkBtn.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        checkBtn.setImage(UIImage(named:"check"), for: .normal)
        self.view.addSubview(checkBtn)


    }
    
    func backButtonAction(){
        self.emailTextField.endEditing(true)
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
