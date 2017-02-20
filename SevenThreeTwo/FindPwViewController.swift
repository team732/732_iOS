//
//  CommentViewController.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 19..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class FindPwViewController: UIViewController,UITextViewDelegate {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    var emailTextView :UITextView!
    var apiManager : ApiManager!
    
    
    var commentSize:CGFloat = 0.0 {
        didSet(oldValue){
            if oldValue > emailTextView.frame.size.height {
                emailTextView.frame.origin.y -= (oldValue - emailTextView.frame.size.height)
                emailTextView.frame.size.height = oldValue
            }else if oldValue < emailTextView.frame.size.height {
                emailTextView.frame.origin.y += (emailTextView.frame.size.height - oldValue)
                emailTextView.frame.size.height = oldValue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        viewSetUp()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor.clear
        
        let backView = UIView(frame: CGRect(x: 0*widthRatio, y: 0*heightRatio, width: 375*widthRatio, height: 667*heightRatio))
        backView.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 0.93)
        self.view.addSubview(backView)
        
        
        let cancelBtn = UIButton(frame: CGRect(x: 176*widthRatio , y: 70*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        cancelBtn.setImage(UIImage(named: "cancelWhite"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        self.view.addSubview(cancelBtn)
        
        
        let findPwView = UIView(frame: CGRect(x: 20*widthRatio, y: 113*heightRatio, width: 335*widthRatio, height: 321*heightRatio))
        
        findPwView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        
        let findPwLabel = UILabel(frame: CGRect(x: 108*widthRatio, y: 36*heightRatio, width: 120*widthRatio, height: 22*heightRatio))
        findPwLabel.text = "비밀번호찾기"
        findPwLabel.textAlignment = .center
        findPwLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        findPwView.addSubview(findPwLabel)
        
        let line = drawLine(startX: 150, startY: 80, width: 36, height: 1, border: false, color: UIColor.black)
        findPwView.addSubview(line)
        
        let findPwMessage = UIImageView(frame: CGRect(x: 65.5*widthRatio, y: 105*heightRatio, width: 205*widthRatio, height: 29*heightRatio))
        findPwMessage.image = UIImage(named: "findPass")
        findPwMessage.sizeToFit()
        findPwView.addSubview(findPwMessage)
        
        
        emailTextView = UITextView(frame: CGRect(x: 17*widthRatio, y: 206*heightRatio, width: 303*widthRatio, height: 30*heightRatio))
        emailTextView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        emailTextView.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 14*widthRatio)
        emailTextView.delegate = self
        emailTextView.returnKeyType = UIReturnKeyType.done
        findPwView.addSubview(emailTextView)
        
        
        
        
        let secLine = drawLine(startX: 16, startY: 237, width: 303, height: 1, border: false, color: UIColor.black)
        findPwView.addSubview(secLine)
        
        
        
        let sendBtn = UIButton(frame: CGRect(x: 16*widthRatio , y: 257*heightRatio, width: 303*widthRatio, height: 48*heightRatio))
        sendBtn.addTarget(self, action: #selector(completeButtonAction), for: .touchUpInside)
        sendBtn.setImage(UIImage(named:"checkBtn"), for: .normal)
        findPwView.addSubview(sendBtn)
        
        
        
        self.view.addSubview(findPwView)
        
        
    }
    
    func cancelButtonAction(){
        self.emailTextView.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    func completeButtonAction(){
        //서버에서 메일
        apiManager = ApiManager(path: "/password-reset", method: .post, parameters: ["email":emailTextView.text], header: [:])
        apiManager.requestFindPw { (enableCode) in
            if enableCode == 0 {
                self.emailAlert(title: "전송되었습니다!", isEnable: true)
            }else if enableCode == -27 {
                self.emailAlert(title: "이메일형식을 확인해주세요", isEnable: false)
            }else{
                self.emailAlert(title: "메일전송실패", isEnable: false)
            }
        }
    }
    
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool, color: UIColor) -> UIView{
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = color
        
        return line
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        
        if(textView.text.characters.count < 141){
            commentSize = emailTextView.contentSize.height
        }else{
            textviewRangeAlert(overMsg: true,message: "긴 이메일은 좋지 않습니다.")
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    
    func textviewRangeAlert(overMsg : Bool,message: String){
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            if overMsg{
                while(self.emailTextView.text.characters.count > 140){
                    self.emailTextView.text.characters.removeLast()
                }
            }
            alertView.dismiss(animated: true, completion: nil)
        })
        
        alertView.addAction(action)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    func emailAlert(title: String,isEnable: Bool){
        let alertView = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            if isEnable{
                self.dismiss(animated: false, completion: nil)
            }
            alertView.dismiss(animated: true, completion: nil)
        })
        
        alertView.addAction(action)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    
}
