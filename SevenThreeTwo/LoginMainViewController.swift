//
//  LoginMainViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 2..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class LoginMainViewController: UIViewController , UITextFieldDelegate{

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    var idTextField : UITextField!
    var pwTextField : UITextField!
    var checkUserLabel : UILabel!
    let placeholderColor : UIColor = UIColor(red: 67/255, green: 68/255, blue: 67/255, alpha: 0.56)
    
    var apiManager : ApiManager!

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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        
        
        
        let logoLandScape = UIImageView(frame: CGRect(x: (167*widthRatio), y: (146*heightRatio), width: 41*widthRatio, height: 99*heightRatio))
        logoLandScape.image = UIImage(named: "logoPortrait")
        self.view.addSubview(logoLandScape)
        
        
        let loginBtn = UIButton(frame: CGRect(x: 38*widthRatio , y: 431*heightRatio, width: 299*widthRatio, height: 48*heightRatio))
        loginBtn.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        loginBtn.setImage(UIImage(named:"login"), for: .normal)
        self.view.addSubview(loginBtn)
        
        
        
        idTextField = UITextField(frame: CGRect(x: 38*widthRatio, y: 340*heightRatio, width: 299*widthRatio, height: 28*heightRatio))
        idTextField.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 14*widthRatio)
        idTextField.autocorrectionType = UITextAutocorrectionType.no
        idTextField.attributedPlaceholder = NSAttributedString(string: "아이디 혹은 이메일", attributes: [NSForegroundColorAttributeName: placeholderColor])
        idTextField.textAlignment = .center
        idTextField.keyboardType = UIKeyboardType.default
        idTextField.returnKeyType = UIReturnKeyType.done
        idTextField.delegate = self
        
        self.view.addSubview(idTextField)
        
        drawLine(startX: 38, startY: 367, width: 299, height: 1, border: false, color: UIColor.black)

        
       
        pwTextField = UITextField(frame: CGRect(x: 38*widthRatio, y: 388*heightRatio, width: 299*widthRatio, height: 28*heightRatio))
        pwTextField.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 14*widthRatio)
        pwTextField.autocorrectionType = UITextAutocorrectionType.no
        pwTextField.keyboardType = UIKeyboardType.default
        pwTextField.returnKeyType = UIReturnKeyType.done
        pwTextField.delegate = self
        pwTextField.attributedPlaceholder = NSAttributedString(string: "패스워드", attributes: [NSForegroundColorAttributeName: placeholderColor])
        pwTextField.isSecureTextEntry = true
        pwTextField.textAlignment = .center
        self.view.addSubview(pwTextField)
        
        
        checkUserLabel = UILabel(frame: CGRect(x: 118*widthRatio, y: 296*heightRatio, width: 141*widthRatio, height: 12*heightRatio))
        checkUserLabel.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        checkUserLabel.isHidden = true
        checkUserLabel.text = ""
        checkUserLabel.textAlignment = .center
        checkUserLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 12*widthRatio)
        self.view.addSubview(checkUserLabel)


        
        
        
        drawLine(startX: 38, startY: 415, width: 299, height: 1, border: false, color: UIColor.black)
        
        
        let joinBtn = UIButton(frame: CGRect(x: 38*widthRatio , y: 580*heightRatio, width: 299*widthRatio, height: 48*heightRatio))
        joinBtn.addTarget(self, action: #selector(joinButtonAction), for: .touchUpInside)
        joinBtn.setImage(UIImage(named:"join"), for: .normal)
        self.view.addSubview(joinBtn)
        
        let missingPw = UIButton(frame: CGRect(x: 118*widthRatio, y: 503*heightRatio, width: 142*widthRatio, height: 12*heightRatio))
        missingPw.setTitle("혹시 패스워드를 잊으셨나요?", for: .normal)
        missingPw.titleLabel?.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 12*widthRatio)
        missingPw.setTitleColor(UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 0.56), for: .normal)
        missingPw.titleLabel?.addTextSpacing(spacing: -0.1*widthRatio)
        missingPw.titleLabel?.textAlignment = .center
        missingPw.addTarget(self, action: #selector(findPwButtonAction), for: .touchUpInside)
        self.view.addSubview(missingPw)
        
        
    }
    
    func loginButtonAction(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let left = storyboard.instantiateViewController(withIdentifier: "left")
        let middle = storyboard.instantiateViewController(withIdentifier: "middle")
        let right = storyboard.instantiateViewController(withIdentifier: "right")
        let top = storyboard.instantiateViewController(withIdentifier: "top")
        
        let snapContainer = SnapContainerViewController.containerViewWith(left,
                                                                          middleVC: middle,
                                                                          rightVC: right,
                                                                          topVC: top,
                                                                          bottomVC: nil)

        CheckTokenViewController.snapContainer = snapContainer
            apiManager = ApiManager(path: "/users/732/token", method: .post, parameters:["loginId":idTextField.text!,"password":pwTextField.text!], header: [:])
            apiManager.requestLogin(completion: { (isLogin) in
                self.checkUserLabel.isHidden = false
                switch (isLogin["meta"]["code"]){
                    case 0:
                        self.checkUserLabel.text = ""
                        let userToken = UserDefaults.standard
                        userToken.set(isLogin["data"]["token"].stringValue, forKey: "token")
                        
                        self.apiManager = ApiManager(path: "/missions/today", method: .get, header: ["authorization":isLogin["data"]["token"].stringValue])
                        self.apiManager.requestMissions(missionText: { (missionText) in
                            MainController.missionText = missionText
                        }) { (missionId) in
                            MainController.missionId = missionId
                            self.present(CheckTokenViewController.snapContainer, animated: true, completion: nil)
                        }
                        //로그인성공
                        break
                    case -10:
                        self.checkUserLabel.text = "존재하지 않는 사용자입니다"
                        //존재하지 않는 사용자
                        break
                    case -31:
                        self.checkUserLabel.text = "존재하지 않는 아이디입니다"
                        //아이디가 없음
                        break
                    case -32:
                        self.checkUserLabel.text = "비밀번호를 확인해주세요"
                        //비밀번호가 틀림
                        break
                    default:
                        break
                }
            })
        
        

    }
    func joinButtonAction(){
        self.performSegue(withIdentifier: "joinToId", sender: self)
    }
    
   
    
    func findPwButtonAction(){
        self.performSegue(withIdentifier: "findPass", sender: self)
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

    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        idTextField.endEditing(true)
        pwTextField.endEditing(true)
    }
    

 

}
