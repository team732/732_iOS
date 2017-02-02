//
//  JoinInputPwViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 2..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class JoinInputPwCheckViewController: UIViewController,UITextFieldDelegate {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    var receivedId: String = ""
    var receivedPw: String = ""
    var pwCheckTextField : UITextField!
    
    var pwHideBtn : UIButton!
    
    var passwordIshidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        viewSetUp()
        
        // Do any additional setup after loading the view.
    }
    
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        let gotoLeft = UIImageView(frame: CGRect(x: (30*widthRatio), y: (79*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        gotoLeft.image = UIImage(named: "gotoleft")
        gotoLeft.sizeToFit()
        self.view.addSubview(gotoLeft)
        
        
        let backBtn = UIButton(frame: CGRect(x: 44*widthRatio , y: 78*heightRatio, width: 27*widthRatio, height: 15*heightRatio))
        backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backBtn.setTitle("뒤로", for: .normal)
        backBtn.setTitleColor(UIColor.black, for: .normal)
        backBtn.titleLabel!.font =  UIFont(name: "아리따-돋움(OTF)-Medium", size: 15*widthRatio)
        backBtn.titleLabel!.font = backBtn.titleLabel!.font.withSize(15*widthRatio)
        
        self.view.addSubview(backBtn)
        
        let pwCheckLabel = UILabel(frame: CGRect(x: 36*widthRatio, y: 146*heightRatio, width: 100*widthRatio, height: 15*heightRatio))
        pwCheckLabel.text = "비밀번호 확인"
        pwCheckLabel.textAlignment = .center
        pwCheckLabel.font = UIFont(name: "아리따-돋움(OTF)-Medium", size: 15*widthRatio)
        pwCheckLabel.font = pwCheckLabel.font.withSize(15*widthRatio)
        self.view.addSubview(pwCheckLabel)
        
        pwCheckTextField = UITextField(frame: CGRect(x: 36*widthRatio, y: 183*heightRatio, width: 305*widthRatio, height: 13*heightRatio))
        pwCheckTextField.placeholder = "비밀번호를 다시 입력하시오.(영어 대소문자,숫자 조합6~16자리)"
        pwCheckTextField.font = UIFont.systemFont(ofSize: 12*widthRatio)
        pwCheckTextField.autocorrectionType = UITextAutocorrectionType.no
        pwCheckTextField.keyboardType = UIKeyboardType.default
        pwCheckTextField.returnKeyType = UIReturnKeyType.done
        pwCheckTextField.delegate = self
        pwCheckTextField.addTarget(self, action: #selector(pwCheckTextFieldChanged), for: UIControlEvents.editingChanged)
        pwCheckTextField.isSecureTextEntry = true

        self.view.addSubview(pwCheckTextField)
        
        drawLine(startX: 35, startY: 201, width: 305, height: 1, border: false, color: UIColor.black)
        
        
        let checkBtn = UIButton(frame: CGRect(x: 35*widthRatio , y: 245*heightRatio, width: 305*widthRatio, height: 41*heightRatio))
        checkBtn.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        checkBtn.setImage(UIImage(named:"check"), for: .normal)
        self.view.addSubview(checkBtn)
        
        pwHideBtn = UIButton(frame: CGRect(x: 311*widthRatio , y: 178*heightRatio, width: 29*widthRatio, height: 15*heightRatio))
        pwHideBtn.addTarget(self, action: #selector(pwHideButtonAction), for: .touchUpInside)
        pwHideBtn.setTitle("보기", for: .normal)
        pwHideBtn.setTitleColor(UIColor.black, for: .normal)
        pwHideBtn.titleLabel!.font =  UIFont(name: "아리따-돋움(OTF)-Medium", size: 15*widthRatio)
        pwHideBtn.titleLabel!.font = pwHideBtn.titleLabel!.font.withSize(15*widthRatio)
        pwHideBtn.isHidden = true
        self.view.addSubview(pwHideBtn)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pwHideButtonAction(){
        if passwordIshidden {
            pwCheckTextField.isSecureTextEntry = false
            pwCheckTextField.font = nil
            pwCheckTextField.font = UIFont.systemFont(ofSize: 12*widthRatio)
            passwordIshidden = false
            pwHideBtn.setTitle("숨김", for: .normal)
        }else{
            passwordIshidden = true
            pwHideBtn.setTitle("보기", for: .normal)
            pwCheckTextField.isSecureTextEntry = true
            
        }
    }
    
    func pwCheckTextFieldChanged(textField: UITextField) {
        if self.pwCheckTextField.text == ""{
            self.pwHideBtn.isHidden = true
        }else{
            self.pwHideBtn.isHidden = false
        }
    }

    
    func backButtonAction(){
        self.pwCheckTextField.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkButtonAction(){
        
        if pwCheckTextField.text == receivedPw{
           // 비밀번호가 이전꺼와 동일하면 넘기고 아니면 안된다.
            self.performSegue(withIdentifier: "pwCheckToNick", sender: self)
        }else{
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pwCheckToNick
        if segue.identifier == "pwCheckToNick"
        {
            let destination = segue.destination as! JoinInputNicknameViewController
            
            destination.receivedId = self.receivedId
            destination.receivedPw = pwCheckTextField.text!
        }
    }
    
    
}
