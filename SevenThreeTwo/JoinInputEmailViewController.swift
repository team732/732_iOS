//
//  JoinInputEmailViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 3..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class JoinInputEmailViewController: UIViewController,UITextFieldDelegate {

    var receivedId :String!
    var receivedPw :String!
    var receivedNickname: String!
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0

    var emailTextField: UITextField!
    var duplicatedEmail : UILabel!

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
        
        let gotoLeft = UIImageView(frame: CGRect(x: (30*widthRatio), y: (79*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        gotoLeft.image = UIImage(named: "gotoleft")
        gotoLeft.sizeToFit()
        self.view.addSubview(gotoLeft)
        
        
        let backBtn = UIButton(frame: CGRect(x: 44*widthRatio , y: 78*heightRatio, width: 27*widthRatio, height: 15*heightRatio))
        backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backBtn.setTitle("뒤로", for: .normal)
        backBtn.setTitleColor(UIColor.black, for: .normal)
        backBtn.titleLabel!.font =  UIFont(name: "Arita-dotum-Medium_OTF", size: 15*widthRatio)
        backBtn.titleLabel!.font = backBtn.titleLabel!.font.withSize(15*widthRatio)
        
        self.view.addSubview(backBtn)
        
        let emailLabel = UILabel(frame: CGRect(x: 36*widthRatio, y: 146*heightRatio, width: 50*widthRatio, height: 15*heightRatio))
        emailLabel.text = "이메일"
        emailLabel.textAlignment = .center
        emailLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 15*widthRatio)
        emailLabel.font = emailLabel.font.withSize(15*widthRatio)
        self.view.addSubview(emailLabel)
        
        emailTextField = UITextField(frame: CGRect(x: 36*widthRatio, y: 183*heightRatio, width: 337*widthRatio, height: 13*heightRatio))
        emailTextField.placeholder = "이메일을 입력해 주세요 (아이디,비밀번호 분실시 사용됩니다.)"
        emailTextField.font = UIFont.systemFont(ofSize: 12*widthRatio)
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.keyboardType = UIKeyboardType.default
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.delegate = self
        
        self.view.addSubview(emailTextField)
        
        drawLine(startX: 35, startY: 201, width: 305, height: 1, border: false, color: UIColor.black)
        
        duplicatedEmail = UILabel(frame: CGRect(x: 36*widthRatio, y: 209*heightRatio, width: 179*widthRatio, height: 13*heightRatio))
        duplicatedEmail.text = "중복되는 이메일이 존재 합니다."
        duplicatedEmail.textAlignment = .center
        duplicatedEmail.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        duplicatedEmail.isHidden = true
        duplicatedEmail.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        duplicatedEmail.font = duplicatedEmail.font.withSize(13*widthRatio)
        self.view.addSubview(duplicatedEmail)
        
        let checkBtn = UIButton(frame: CGRect(x: 35*widthRatio , y: 245*heightRatio, width: 305*widthRatio, height: 41*heightRatio))
        checkBtn.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        checkBtn.setImage(UIImage(named:"check"), for: .normal)
        self.view.addSubview(checkBtn)
        
    }
    
    func backButtonAction(){
        self.emailTextField.endEditing(true)
        self.dismiss(animated: true, completion: nil)
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
    
    func checkButtonAction(){
        
        var checkNick :Bool = false // 서버에서 확인하는 함수를 불린값으로 리턴
        
        //서버에서 아이디가 중복된게 있으면 duplicatedId 를 isHidden 을 false
        if emailTextField.text == "a" {
            duplicatedEmail.isHidden = false
        }else{
            
            // 이곳에서 서버에 저장시키고 다시 로그인 화면으로 돌아간다.
            // receivedId, receivedPw, receivedNickname, emailTextField.text
            self.emailTextField.endEditing(true)
            self.performSegue(withIdentifier: "emailToLogin", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //emailToLogin
        
        
    }
 

}
