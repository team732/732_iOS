//
//  JoinInputPwViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 2..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class JoinInputPwViewController: UIViewController,UITextFieldDelegate {

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    var receivedId: String = ""
    
    var pwTextField : UITextField!
    var checkPw: UILabel!
    
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
        
        let gotoLeft = UIImageView(frame: CGRect(x: (36.7*widthRatio), y: (67.7*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        gotoLeft.image = UIImage(named: "gotoleft")
        gotoLeft.sizeToFit()
        self.view.addSubview(gotoLeft)
        
        
        let backBtn = UIButton(frame: CGRect(x: 26.7*widthRatio , y: 57.7*heightRatio, width: 34*widthRatio, height: 34*heightRatio))
        backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        self.view.addSubview(backBtn)
        
        let pwLabel = UILabel(frame: CGRect(x: 36*widthRatio, y: 146*heightRatio, width: 63*widthRatio, height: 15*heightRatio))
        pwLabel.text = "비밀번호"
        pwLabel.textAlignment = .center
        pwLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 15*widthRatio)
        pwLabel.font = pwLabel.font.withSize(15*widthRatio)
        self.view.addSubview(pwLabel)
        
        pwTextField = UITextField(frame: CGRect(x: 36*widthRatio, y: 183*heightRatio, width: 305*widthRatio, height: 13*heightRatio))
        pwTextField.placeholder = "비밀번호를 입력해주세요 (영어 대소문자,숫자 가능6~16자리)"
        pwTextField.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 12*widthRatio)
        pwTextField.autocorrectionType = UITextAutocorrectionType.no
        pwTextField.keyboardType = UIKeyboardType.default
        pwTextField.returnKeyType = UIReturnKeyType.done
        pwTextField.delegate = self
        pwTextField.addTarget(self, action: #selector(pwTextFieldChanged), for: UIControlEvents.editingChanged)
        pwTextField.isSecureTextEntry = true
        self.view.addSubview(pwTextField)
        
        
        checkPw = UILabel(frame: CGRect(x: 36*widthRatio, y: 209*heightRatio, width: 179*widthRatio, height: 13*heightRatio))
        checkPw.text = " 비밀번호 형식을 확인해주세요."
        checkPw.textAlignment = .left
        checkPw.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        checkPw.isHidden = true
        checkPw.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        self.view.addSubview(checkPw)
        
        drawLine(startX: 35, startY: 201, width: 305, height: 1, border: false, color: UIColor.black)
        
        
        let checkBtn = UIButton(frame: CGRect(x: 35*widthRatio , y: 245*heightRatio, width: 305*widthRatio, height: 41*heightRatio))
        checkBtn.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        checkBtn.setImage(UIImage(named:"check"), for: .normal)
        self.view.addSubview(checkBtn)
        
        pwHideBtn = UIButton(frame: CGRect(x: 311*widthRatio , y: 178*heightRatio, width: 29*widthRatio, height: 15*heightRatio))
        pwHideBtn.addTarget(self, action: #selector(pwHideButtonAction), for: .touchUpInside)
        pwHideBtn.setTitle("보기", for: .normal)
        pwHideBtn.setTitleColor(UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1), for: .normal)
        pwHideBtn.titleLabel!.font =  UIFont(name: "Arita-dotum-Medium_OTF", size: 15*widthRatio)
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
        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        
        self.view.addSubview(line)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonAction(){
        self.pwTextField.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkButtonAction(){
        if !regexPassword(pwTextField.text!) {
            checkPw.isHidden = false
        }else{
            checkPw.isHidden = true
            self.performSegue(withIdentifier: "pwCheck", sender: self)
        }// 세그에 저장시키고 넘겨라
    }
    
    func pwHideButtonAction(){
        if passwordIshidden {
            
            pwTextField.isSecureTextEntry = false
            pwTextField.font = nil
            pwTextField.font = UIFont.systemFont(ofSize: 12*widthRatio)
            passwordIshidden = false
            pwHideBtn.setTitle("숨김", for: .normal)
        }else{
            passwordIshidden = true
            pwHideBtn.setTitle("보기", for: .normal)
            pwTextField.isSecureTextEntry = true

        }
    }
    
    func pwTextFieldChanged(textField: UITextField) {
        if self.pwTextField.text == ""{
            self.pwHideBtn.isHidden = true
        }else{
            self.pwHideBtn.isHidden = false
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //pwCheck
        if segue.identifier == "pwCheck"
        {
            let destination = segue.destination as! JoinInputPwCheckViewController
            
            destination.receivedId = self.receivedId
            destination.receivedPw = pwTextField.text!
        }
        
    }
    
    
    
    func regexPassword(_ password : String) -> Bool{
        
        
        let password = password
        let capitalLetterRegEx  = "^[A-Za-z0-9]{6,16}$"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: password)
        
        return capitalresult
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pwTextField.endEditing(true)
    }

}
