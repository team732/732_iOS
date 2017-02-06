//
//  JoinInputNicknameViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 3..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class JoinInputNicknameViewController: UIViewController,UITextFieldDelegate {

    var receivedId :String!
    var receivedPw :String!
    
    var duplicatedNick : UILabel!
    var nickTextField : UITextField!
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
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
        
        let nickLabel = UILabel(frame: CGRect(x: 36*widthRatio, y: 146*heightRatio, width: 41*widthRatio, height: 15*heightRatio))
        nickLabel.text = "닉네임"
        nickLabel.textAlignment = .center
        nickLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 15*widthRatio)
        nickLabel.font = nickLabel.font.withSize(15*widthRatio)
        self.view.addSubview(nickLabel)
        
        nickTextField = UITextField(frame: CGRect(x: 36*widthRatio, y: 183*heightRatio, width: 305*widthRatio, height: 13*heightRatio))
        nickTextField.placeholder = "닉네임을 입력해 주세요(1~12자리)"
        nickTextField.font = UIFont.systemFont(ofSize: 13*widthRatio)
        nickTextField.autocorrectionType = UITextAutocorrectionType.no
        nickTextField.keyboardType = UIKeyboardType.default
        nickTextField.returnKeyType = UIReturnKeyType.done
        nickTextField.delegate = self
        
        self.view.addSubview(nickTextField)
        
        drawLine(startX: 35, startY: 201, width: 305, height: 1, border: false, color: UIColor.black)
        
        duplicatedNick = UILabel(frame: CGRect(x: 36*widthRatio, y: 209*heightRatio, width: 179*widthRatio, height: 13*heightRatio))
        duplicatedNick.text = "중복되는 닉네임이 존재 합니다."
        duplicatedNick.textAlignment = .center
        duplicatedNick.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        duplicatedNick.isHidden = true
        duplicatedNick.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        duplicatedNick.font = duplicatedNick.font.withSize(13*widthRatio)
        self.view.addSubview(duplicatedNick)
        
        let checkBtn = UIButton(frame: CGRect(x: 35*widthRatio , y: 245*heightRatio, width: 305*widthRatio, height: 41*heightRatio))
        checkBtn.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        checkBtn.setImage(UIImage(named:"check"), for: .normal)
        self.view.addSubview(checkBtn)
        
    }
    
    func backButtonAction(){
        self.nickTextField.endEditing(true)
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
        if nickTextField.text == "a" {
            duplicatedNick.isHidden = false
        }else{
            self.nickTextField.endEditing(true)
            self.performSegue(withIdentifier: "nickToEmail", sender: self)
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // nickToEmail
        if segue.identifier == "nickToEmail"
        {
            let destination = segue.destination as! JoinInputEmailViewController
            
            destination.receivedId = self.receivedId
            destination.receivedPw = self.receivedPw
            destination.receivedNickname = self.nickTextField.text!
        }
    }
 

}
