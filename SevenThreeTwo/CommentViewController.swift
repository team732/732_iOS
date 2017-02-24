//
//  CommentViewController.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 10..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UITextViewDelegate {

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    var commentTextView :UITextView!
    var users = UserDefaults.standard
    var userToken : String!
    var apiManager : ApiManager!
    
 
    var commentSize:CGFloat = 0.0 {
        didSet(oldValue){
            if oldValue > commentTextView.frame.size.height {
                commentTextView.frame.origin.y -= (oldValue - commentTextView.frame.size.height)
                commentTextView.frame.size.height = oldValue
            }else if oldValue < commentTextView.frame.size.height {
                commentTextView.frame.origin.y += (commentTextView.frame.size.height - oldValue)
                commentTextView.frame.size.height = oldValue
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        userToken = users.string(forKey: "token")
        viewSetUp()
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //사라질때 reload 라는 옵저버를 보낸다.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
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
        
        
        let commentView = UIView(frame: CGRect(x: 20*widthRatio, y: 113*heightRatio, width: 335*widthRatio, height: 321*heightRatio))
        
        commentView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)

        
        let commentLabel = UILabel(frame: CGRect(x: 128*widthRatio, y: 36*heightRatio, width: 81*widthRatio, height: 22*heightRatio))
        commentLabel.text = "댓글달기"
        commentLabel.textAlignment = .center
        commentLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        commentView.addSubview(commentLabel)
        
        let line = drawLine(startX: 150, startY: 80, width: 36, height: 1, border: false, color: UIColor.black)
        commentView.addSubview(line)
        
        let spacingImg = UIImageView(frame: CGRect(x: 335*widthRatio/2 - 94*widthRatio, y: 105*heightRatio, width: 188*widthRatio, height: 11*heightRatio))
        spacingImg.image = UIImage(named: "spacing")
        commentView.addSubview(spacingImg)

        
        commentTextView = UITextView(frame: CGRect(x: 17*widthRatio, y: 206*heightRatio, width: 303*widthRatio, height: 30*heightRatio))
        commentTextView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        commentTextView.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 14*widthRatio)
        commentTextView.delegate = self
        commentTextView.returnKeyType = UIReturnKeyType.done
        commentView.addSubview(commentTextView)
        
        
        
        
        let secLine = drawLine(startX: 16, startY: 237, width: 303, height: 1, border: false, color: UIColor.black)
        commentView.addSubview(secLine)
        
        
        
        let writeCompleteBtn = UIButton(frame: CGRect(x: 16*widthRatio , y: 257*heightRatio, width: 303*widthRatio, height: 48*heightRatio))
        writeCompleteBtn.addTarget(self, action: #selector(completeButtonAction), for: .touchUpInside)
        writeCompleteBtn.setImage(UIImage(named:"checkBtn"), for: .normal)
        commentView.addSubview(writeCompleteBtn)
        
        
        
        self.view.addSubview(commentView)
        
    
    }
    
    func cancelButtonAction(){
        self.commentTextView.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    func completeButtonAction(){
                
        apiManager = ApiManager(path: "/contents/\(SelectListViewController.receivedCid)/replies", method: .post, parameters: ["reply":self.commentTextView.text], header: ["authorization":userToken])
        apiManager.requestWriteComment { (isComment) in
            switch isComment {
            case 0:
                self.commentTextView.endEditing(true)
                self.dismiss(animated: false, completion: nil)
                break
            case -10:
                self.textviewRangeAlert(overMsg: false,message: "앗! 댓글을 달 수 없습니다.")
                break
            default:
                break
            }
        }
        
        //서버에 댓글 작성하고 dismiss
       
    }


    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool, color: UIColor) -> UIView{
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        
        return line
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        
        if(textView.text.characters.count < 141){
            commentSize = commentTextView.contentSize.height
        }else{
            textviewRangeAlert(overMsg: true,message: "긴 댓글은 좋지 않습니다.")
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
                while(self.commentTextView.text.characters.count > 140){
                    self.commentTextView.text.characters.removeLast()
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
    

}
