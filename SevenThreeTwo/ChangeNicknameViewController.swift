//
//  ChangeNicknameViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 15..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class ChangeNicknameViewController: UIViewController, UITextFieldDelegate {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    var apiManager : ApiManager!
    var users = UserDefaults.standard
    var userToken : String!
    var backBtn : UIButton!
    
    var backBtnExtension : UIView!
    var mainLabel : UILabel!
    var newNickname : UITextField!
    var reEnterNickname : UITextField!
    
    var checkNicknameLabel : UILabel!
    //    var duplicateLabel : UILabel!
    
    var checkBtn : UIButton!
    
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
        
        mainLabel = UILabel(frame: CGRect(x: 134*widthRatio, y: 90*heightRatio, width: 107*widthRatio, height: 22*heightRatio))
        mainLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        mainLabel.textAlignment = .center
        mainLabel.text = "닉네임 변경"
        self.view.addSubview(mainLabel)
        
        //gotoleft
        backBtn = UIButton(frame: CGRect(x: 30*widthRatio, y: 87*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        backBtn.setImage(UIImage(named: "gotoleft"), for: .normal)
        backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backBtn.sizeToFit()
        self.view.addSubview(backBtn)
        
        backBtnExtension = UIView(frame: CGRect(x: 30*widthRatio, y: 87*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        backBtnExtension.backgroundColor = UIColor.clear
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(backButtonAction))
        backBtnExtension.isUserInteractionEnabled = true
        backBtnExtension.addGestureRecognizer(tapGestureRecognizer)
        self.view.addSubview(backBtnExtension)
        
        newNickname = UITextField(frame: CGRect(x: 36*widthRatio, y: 229*heightRatio, width: 337*widthRatio, height: 13*heightRatio))
        newNickname.placeholder = "새로운 닉네임을 입력해 주세요(1~12자리)"
        newNickname.font = UIFont.systemFont(ofSize: 12*widthRatio)
        newNickname.autocorrectionType = UITextAutocorrectionType.no
        newNickname.keyboardType = UIKeyboardType.default
        newNickname.returnKeyType = UIReturnKeyType.done
        newNickname.delegate = self
        
        self.view.addSubview(newNickname)
        
        //        duplicateLabel = UILabel(frame: CGRect(x: 161*widthRatio, y: 229*heightRatio, width: 179*widthRatio, height: 13*heightRatio))
        //        duplicateLabel.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        //        duplicateLabel.isHidden = true
        //        duplicateLabel.textAlignment = .right
        //        duplicateLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        //        // 중복인지 , 형식에 안맞는지 체크
        //
        //        self.view.addSubview(duplicateLabel)
        //
        
        drawLine(startX: 35, startY: 246, width: 305, height: 1, border: false, color: UIColor.black)
        
        reEnterNickname = UITextField(frame: CGRect(x: 36*widthRatio, y: 275*heightRatio, width: 337*widthRatio, height: 13*heightRatio))
        reEnterNickname.placeholder = "새로운 닉네임 확인"
        reEnterNickname.font = UIFont.systemFont(ofSize: 12*widthRatio)
        reEnterNickname.autocorrectionType = UITextAutocorrectionType.no
        reEnterNickname.keyboardType = UIKeyboardType.default
        reEnterNickname.returnKeyType = UIReturnKeyType.done
        reEnterNickname.delegate = self
        
        self.view.addSubview(reEnterNickname)
        
        
        checkNicknameLabel = UILabel(frame: CGRect(x: 35*widthRatio, y: 298*heightRatio, width: 200*widthRatio, height: 13*heightRatio))
        checkNicknameLabel.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        checkNicknameLabel.isHidden = true
        checkNicknameLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        
        self.view.addSubview(checkNicknameLabel)
        
        drawLine(startX: 35, startY: 292, width: 305, height: 1, border: false, color: UIColor.black)
        
        let checkBtn = UIButton(frame: CGRect(x: 35*widthRatio , y: 336*heightRatio, width: 305*widthRatio, height: 41*heightRatio))
        checkBtn.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        checkBtn.setImage(UIImage(named:"check"), for: .normal)
        self.view.addSubview(checkBtn)
        
        
    }
    
    func backButtonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func checkButtonAction(){
        
        checkNicknameLabel.isHidden = true
        if newNickname.text == "" {
            checkNicknameLabel.text = "닉네임 형식이 맞지않습니다"
            checkNicknameLabel.isHidden = false
        } else if newNickname.text != reEnterNickname.text {
            checkNicknameLabel.text = "새로운 닉네임이 일치하지 않습니다"
            checkNicknameLabel.isHidden = false
        } else{
            
            apiManager = ApiManager(path: "/users/me/nickname", method: .put, parameters: ["nickname":newNickname.text!], header: ["authorization":userToken!])
            
            apiManager.requestSetInfo { (isChanged) in
                switch (isChanged){
                case 0:
                    self.performSegue(withIdentifier: "complete", sender: self)
                    break
                case -10:
                    self.checkNicknameLabel.text = "닉네임 형식이 맞지않습니다"
                    self.checkNicknameLabel.isHidden = false
                    break
                case -34:
                    self.checkNicknameLabel.text = "중복된 닉네임입니다"
                    self.checkNicknameLabel.isHidden = false
                    break
                default:
                    break
                }
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
        line.backgroundColor = color
        
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
            
            destination.receivedStatusMsg = 2
        }
    }
    

    
}
