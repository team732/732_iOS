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
    var apiManager : ApiManager!
    var users = UserDefaults.standard
    var userToken : String!
    var backBtn : UIButton!
    var mainLabel : UILabel!
    var oriPassword : UITextField!
    var newPassword : UITextField!
    var reEnterPassword : UITextField!
    
    var oriCheckLabel : UILabel!
    var newCheckLabel : UILabel!
    
    var checkBtn : UIButton!
    var backBtnExtension : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        userToken = users.string(forKey: "token")
        viewSetUp()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        mainLabel = UILabel(frame: CGRect(x: 129*widthRatio, y: 67.7*heightRatio, width: 119*widthRatio, height: 22*heightRatio))
        mainLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        mainLabel.textAlignment = .center
        mainLabel.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        mainLabel.text = "비밀번호 변경"
        mainLabel.addTextSpacing(spacing: -1)
        self.view.addSubview(mainLabel)
        
        //gotoleft
        backBtn = UIButton(frame: CGRect(x: 36.7*widthRatio, y: 67.7*heightRatio, width: 8.2*widthRatio, height: 8.2*heightRatio))
        backBtn.setImage(UIImage(named: "gotoleft"), for: .normal)
        backBtn.addTarget(self, action: #selector(SettingViewController.backButtonAction), for: .touchUpInside)
        backBtn.sizeToFit()
        self.view.addSubview(backBtn)
        
        backBtnExtension = UIView(frame: CGRect(x: 26.7*widthRatio, y: 57.7*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        backBtnExtension.backgroundColor = UIColor.clear
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(backButtonAction))
        backBtnExtension.isUserInteractionEnabled = true
        backBtnExtension.addGestureRecognizer(tapGestureRecognizer)
        self.view.addSubview(backBtnExtension)
        
        
        oriPassword = UITextField(frame: CGRect(x: 36*widthRatio, y: 229*heightRatio, width: 337*widthRatio, height: 13*heightRatio))
        oriPassword.placeholder = "기존 비밀번호를 입력해 주세요"
        oriPassword.font = UIFont.systemFont(ofSize: 12*widthRatio)
        oriPassword.autocorrectionType = UITextAutocorrectionType.no
        oriPassword.keyboardType = UIKeyboardType.default
        oriPassword.returnKeyType = UIReturnKeyType.done
        oriPassword.delegate = self
        
        self.view.addSubview(oriPassword)
        
        oriCheckLabel = UILabel(frame: CGRect(x: 161*widthRatio, y: 228*heightRatio, width: 179*widthRatio, height: 13*heightRatio))
        oriCheckLabel.textAlignment = .right
        oriCheckLabel.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        oriCheckLabel.isHidden = true
        oriCheckLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        oriCheckLabel.text = "잘못된 비밀번호 입니다."
        
        self.view.addSubview(oriCheckLabel)
        
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
        
        newCheckLabel = UILabel(frame: CGRect(x: 35*widthRatio, y: 386*heightRatio, width: 216*widthRatio, height: 13*heightRatio))
        newCheckLabel.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        newCheckLabel.isHidden = true
        newCheckLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        //위에 입력한거랑 다른건지 형식에 안맞는건지 확인
        
        self.view.addSubview(newCheckLabel)
        
        
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
        apiManager = ApiManager(path: "/users/me/password", method: .put, parameters: ["password":oriPassword.text!,"newPassword":newPassword.text!,"reEnterNewPassword":reEnterPassword.text!], header: ["authorization":userToken!])
        newCheckLabel.isHidden = true
        oriCheckLabel.isHidden = true
        apiManager.requestSetInfo { (isChanged) in
            switch (isChanged){
            case 0:
                self.performSegue(withIdentifier: "complete", sender: self)
                break
            case -26:
                self.newCheckLabel.text = "비밀번호를 확인해주세요"
                self.newCheckLabel.isHidden = false
                break
            case -28:
                self.newCheckLabel.text = "비밀번호 형식을 확인해주세요"
                self.newCheckLabel.isHidden = false
                break
            case -32:
                self.oriCheckLabel.isHidden = false
                break
            default:
                break
            }
        }
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
    
    func textField(_ textField: UITextField, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textField.resignFirstResponder()
        }
        return true
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "complete"
        {
            let destination = segue.destination as! ChangeCompleteViewController
            
            destination.receivedStatusMsg = 1
        }
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
