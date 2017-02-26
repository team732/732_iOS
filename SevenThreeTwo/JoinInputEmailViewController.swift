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
    var checkEmailLabel : UILabel!
    var apiManager : ApiManager!
    
    var checkEmail :Bool = true{
        didSet{
            if checkEmail{
                
                checkEmailLabel.text = "중복되는 이메일이 존재 합니다."
                checkEmailLabel.textAlignment = .center
                checkEmailLabel.isHidden = false

            }else{
                
                checkEmailLabel.isHidden = true
                self.emailTextField.endEditing(true)
                joinOurService(id: receivedId, password: receivedPw, nickname: receivedNickname, email: emailTextField.text!)

            }
        }
    }

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
        
        let gotoLeft = UIImageView(frame: CGRect(x: (36.7*widthRatio), y: (67.7*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        gotoLeft.image = UIImage(named: "gotoleft")
        gotoLeft.sizeToFit()
        self.view.addSubview(gotoLeft)
        
        let backBtn = UIButton(frame: CGRect(x: 26.7*widthRatio , y: 57.7*heightRatio, width: 34*widthRatio, height: 34*heightRatio))
        backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        let emailLabel = UILabel(frame: CGRect(x: 36*widthRatio, y: 146*heightRatio, width: 50*widthRatio, height: 15*heightRatio))
        emailLabel.text = "이메일"
        emailLabel.textAlignment = .center
        emailLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 15*widthRatio)
        emailLabel.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        self.view.addSubview(emailLabel)
        
        let emailLabel2 = UILabel(frame: CGRect(x: 85*widthRatio, y: 148*heightRatio, width: 180*widthRatio, height: 11*heightRatio))
        emailLabel2.text = "(아이디나 비밀번호 분실 시 사용됩니다)"
        emailLabel2.textAlignment = .center
        emailLabel2.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 11*widthRatio)
        emailLabel2.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        self.view.addSubview(emailLabel2)
        
        let emailSub = UILabel(frame: CGRect(x: 85*widthRatio, y: 148*heightRatio, width: 180*widthRatio, height: 11*heightRatio))
        emailSub.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        emailSub.text = "(비밀번호 분실 시 사용됩니다)"
        
        emailTextField = UITextField(frame: CGRect(x: 36*widthRatio, y: 183*heightRatio, width: 337*widthRatio, height: 13*heightRatio))
        emailTextField.placeholder = "이메일을 입력해주세요"
        emailTextField.font = UIFont.systemFont(ofSize: 12*widthRatio)
        emailTextField.autocorrectionType = UITextAutocorrectionType.no
        emailTextField.keyboardType = UIKeyboardType.default
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.delegate = self
        
        self.view.addSubview(emailTextField)
        
        drawLine(startX: 35, startY: 201, width: 305, height: 1, border: false, color: UIColor.black)
        
        checkEmailLabel = UILabel(frame: CGRect(x: 36*widthRatio, y: 209*heightRatio, width: 179*widthRatio, height: 13*heightRatio))
        checkEmailLabel.textColor =  UIColor(red: 208/255, green: 2/255, blue: 27/255, alpha: 1.0)
        checkEmailLabel.isHidden = true
        checkEmailLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        self.view.addSubview(checkEmailLabel)
        
        let checkBtn = UIButton(frame: CGRect(x: 35*widthRatio , y: 245*heightRatio, width: 305*widthRatio, height: 41*heightRatio))
        checkBtn.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        checkBtn.setImage(UIImage(named:"check"), for: .normal)
        self.view.addSubview(checkBtn)
        
        let skipBtn = UIButton(frame: CGRect(x: 275*widthRatio , y: 75*heightRatio, width: 61*widthRatio, height: 15*heightRatio))
        skipBtn.addTarget(self, action: #selector(skipButtonAction), for: .touchUpInside)
        skipBtn.setImage(UIImage(named:"skip"), for: .normal)
        self.view.addSubview(skipBtn)
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
        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        
        self.view.addSubview(line)
    }
    
    func checkButtonAction(){
    
        checkDuplicated()

        
    }
    
    func checkDuplicated(){
        
        if let userEmail = emailTextField.text ,userEmail != ""{
            apiManager = ApiManager(path: "/email/"+userEmail+"/checking", method: .get, parameters: [:],header:[:])
            apiManager.requsetCheckDuplicated(completion: { (isDuplicated) in
                
                
                if  isDuplicated["meta"]["code"].intValue != -27 {
                    self.checkEmail = isDuplicated["data"]["isDuplicated"].boolValue
                }else{
                    self.checkEmailLabel.text = " 이메일 형식이 아닙니다."
                    self.checkEmailLabel.textAlignment = .left
                    self.checkEmailLabel.isHidden = false
                }
            })
        }else{
            self.checkEmailLabel.text = " 이메일 형식이 아닙니다."
            self.checkEmailLabel.textAlignment = .left
            self.checkEmailLabel.isHidden = false
        }
        
    }
    
    func skipButtonAction(){
        
        
        joinOurService(id: receivedId, password: receivedPw, nickname: receivedNickname,email: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //emailToLogin
    }
    
    func joinOurService(id: String,password: String, nickname: String, email: String?){
        
        apiManager = ApiManager(path: "/users", method: .post, parameters: ["loginId":id,"password":password,"reEnterPassword":password,"nickname":nickname], header: [:])

        if email != nil {
            let email = email!
            apiManager.parameters.updateValue(email, forKey: "email")
        }
        apiManager.requestJoin { (isJoin) in
            
            let userToken = UserDefaults.standard
            userToken.set(isJoin["data"]["token"].stringValue, forKey: "token")
            
            
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
            
            self.apiManager = ApiManager(path: "/missions/today", method: .get, header: ["authorization":isJoin["data"]["token"].stringValue])
            self.apiManager.requestMissions(missionText: { (missionText) in
                MainController.missionText = missionText
            }) { (missionId) in
                MainController.missionId = missionId
                let fcmToken : String = userToken.string(forKey: "pushToken")!
                
                self.apiManager = ApiManager(path: "/users/me/fcm", method: .put, parameters:["fcmToken":fcmToken], header: ["authorization":isJoin["data"]["token"].stringValue])
                self.apiManager.requestPushToken(completion: { (isPush) in
                    if isPush == 0 {
                        self.present(CheckTokenViewController.snapContainer, animated: true, completion: nil)
                        //만약 푸시토큰을 not allow 했다면? -> 체크하기
                    }
                })
            }

        }
        // request
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailTextField.endEditing(true)
    }

}
