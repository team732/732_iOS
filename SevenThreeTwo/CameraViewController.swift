//
//  CameraViewController.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 1. 23..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class CameraViewController: UIViewController,UITextViewDelegate {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    
    // 기기의 너비와 높이
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var inputText: UITextView!
    
    @IBOutlet weak var grayView: UIView!
    
    var backBtnExtension : UIView!
    
    var receivedImg : UIImage = UIImage(named : "gotoleft")!
    var receivedMissionId : Int = 0

    var apiManager : ApiManager!
    let userToken = UserDefaults.standard
    
    var placeHolderText : String = "140자 이내로 작성해주세요."
    var commentSize : CGFloat = 0.0
   
    var emojiFlag : Int = 0   // 0 처음에 들어왔을 때 /1 이모지 다음으로 들어왔을 때
    
    
    //var imageWidth : CGFloat?
    //var imageHeight : CGFloat?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let imageWidth = CGFloat((self.receivedImg.size.width))
        let imageHeight = CGFloat((self.receivedImg.size.height))
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        if imageWidth > imageHeight{
            imageView.frame = CGRect(x: (20*widthRatio), y: (149*heightRatio), width: 335*widthRatio, height: (253*heightRatio))
            
        }else if imageHeight > imageWidth{
            imageView.frame = CGRect(x: (37.5*widthRatio), y: (75*heightRatio), width: 300*widthRatio, height: (400*heightRatio))
            
        }else{
            imageView.frame = CGRect(x: (20*widthRatio), y: (108*heightRatio), width: 335*widthRatio, height: (335)*heightRatio)
        }
        
        backBtn.frame = CGRect(x: (30*widthRatio), y: (30*heightRatio), width: 24*widthRatio, height: 24*heightRatio)
        backBtn.setImage(UIImage(named:"gotoleft"), for: .normal)
        backBtn.tintColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1.0)
        backBtn.sizeToFit()
        
        backBtnExtension = UIView(frame: CGRect(x: 20*widthRatio, y: 25*heightRatio, width: 30*widthRatio, height: 30*heightRatio))
        backBtnExtension.backgroundColor = UIColor.clear
        //backBtnExtension.layer.borderWidth = 1
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(closeBtn(_:)))
        backBtnExtension.isUserInteractionEnabled = true
        backBtnExtension.addGestureRecognizer(tapGestureRecognizer)
        self.view.addSubview(backBtnExtension)
        
        nextBtn.frame = CGRect(x: (312*widthRatio), y: (30*heightRatio), width: 34*widthRatio, height: 18*heightRatio)
        nextBtn.setImage(UIImage(named:"share"), for: .normal)
        nextBtn.tintColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1.0)
        nextBtn.sizeToFit()
        
        grayView.frame = CGRect(x: 0*widthRatio, y: 512.5*heightRatio, width: 375*widthRatio, height: 154.5*heightRatio)
        grayView.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 0.17)

        inputText.frame = CGRect(x: (40*widthRatio), y: (20.5*heightRatio), width: 295*widthRatio, height: (75)*heightRatio)
        inputText.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        inputText.backgroundColor = UIColor.clear
        inputText.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        inputText.text = placeHolderText
        
//        nextBtn.frame = CGRect(x: (12*widthRatio), y: ((622-3)*heightRatio), width: 351*widthRatio, height: 45*heightRatio)
//        nextBtn.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
//        nextBtn.setTitle("게시글 공유", for: .normal)
//        nextBtn.setTitleColor(UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1.0), for: .normal)
//        nextBtn.titleLabel?.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 18*widthRatio)
//        
//        nextBtn.layer.borderWidth = 1
//        nextBtn.layer.borderColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1.0).cgColor

//        var line: UIView!
//        
//        
//        line = UIView(frame: CGRect(x: 0*widthRatio, y: 622*heightRatio, width: 375*widthRatio, height: 0.5*heightRatio))
//        
//        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1.0)//UIColor.gray
//        view.addSubview(line)
        
        // 키패드에게 알림을 줘서 키보드가 보여질 때 사라질 때의 함수를 실행시킨다
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        inputText.endEditing(true) // textBox는 textFiled 오브젝트 outlet 연동할때의 이름.
        
        self.view.frame.origin.y = 0
        //항상 일반 한글 키보드 시점으로 맞춰주어 emoji keyboard 끝나고 바깥 부분을 터치해도 문제가 없음.
        self.emojiFlag = 0
    }
    // 키보드가 보여지면..
    func keyboardWillShow(notification:NSNotification) {
        print("keywillshow : \(emojiFlag)")
        adjustingHeight(show: false, notification: notification)
    }
    
    // 키보드가 사라지면..
    func keyboardWillHide(notification:NSNotification) {
        print("keywillhide : \(emojiFlag)")
        adjustingHeight(show: true, notification: notification)
        
    }
    
    // 높이를 조정한다 ..
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        //216(normal keyboard height)+42 => emoji keyboard height
        let changeInEmoji : CGFloat = (42 * self.heightRatio) * (show ? 1 : -1)
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            print(changeInHeight)
            
            //emoji 일때
            if self.inputText.textInputMode?.primaryLanguage == nil{
                self.view.frame.origin.y += changeInEmoji
                
                self.emojiFlag = 1
                
            }
            //처음에 한글인지 이모지다음에 한글인지 알 수 있다면 여기서 걸러낼수 있을텐데...
            // 일반적인 한글모드 일때
            else if self.inputText.textInputMode?.primaryLanguage == "ko-KR" && self.emojiFlag == 0 {
             
                
                self.view.frame.origin.y += changeInHeight
                
                
            }// 이모지다음에 한글일 때
            else if self.inputText.textInputMode?.primaryLanguage == "ko-KR" && self.emojiFlag == 1 {
                
                
                self.view.frame.origin.y += (42 * self.heightRatio)
                self.emojiFlag = 0
                
            }// 한글 제외한 언어일 때
            else{
                
                self.view.frame.origin.y += changeInHeight
                self.emojiFlag = 0
            }
        })
        
    }
    
    //MARK: textView에 placeholder 넣기
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeHolderText{
            textView.textColor = UIColor.black
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == ""{
            textView.textColor = UIColor.gray//UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
            textView.text = placeHolderText
        }
        textView.resignFirstResponder()
    }
    
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        
        if(textView.text.characters.count < 141){
            commentSize = inputText.contentSize.height
        }else{
            textviewRangeAlert(message: "140자를 넘지 말아주세요.")
        }
    }
    
    func textviewRangeAlert(message: String){
        
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.inputText.text.characters.removeLast()
            //해주지 않으면 자꾸 editing이 끝나지않아 뒤에 자판이 눌림...
            self.inputText.endEditing(true)
            self.view.frame.origin.y = 0
            alertView.dismiss(animated: true, completion: nil)
        })
        
        alertView.addAction(action)
        alertWindow(alertView: alertView)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        imageView.image = receivedImg
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        
        let alertView = UIAlertController(title: "", message: "지금 나가면 메인으로 나가게 됩니다.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "나가기", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            alertView.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
        
        alertView.addAction(action)
        alertView.addAction(cancelAction)
        
        alertWindow(alertView: alertView)

    }
    @IBAction func nextBtn(_ sender: UIButton) {
        
        let token = userToken.string(forKey: "token")
        
        if token != nil{
            
            self.apiManager = ApiManager(path: "/missions/\(receivedMissionId)/contents", method: .post, parameters: [:], header: ["authorization":token!])
            
            //아무것도 입력 안했을 때 빈칸처리되서 들어감.
            if self.inputText.text == placeHolderText{
                print("empty space")
                self.inputText.text = ""
            }
            
            let alertView = UIAlertController(title: "", message: "공개 여부를 선택해주세요.", preferredStyle: .alert)
            
            let shareAction = UIAlertAction(title: "공개하기", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
                print("공유하기")
                
                self.apiManager.requestUpload(imageData:self.resizing(self.receivedImg)!, text: self.inputText.text, share:true, completion: { (result) in
                    
                                //print("resultCode : \(result)")
                                //서버 통신이 끝나야 메인으로 돌아감.
                    
                                alertView.dismiss(animated: true, completion: nil)
                                self.dismiss(animated: true, completion: nil)
                            })
                
            })
            
            let noShareAction = UIAlertAction(title: "나만보기", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
                print("나만보기")
                
                self.apiManager.requestUpload(imageData: self.resizing(self.receivedImg)!, text: self.inputText.text, share:false, completion: { (result) in
                    
                    //print("resultCode : \(result)")
                    //서버 통신이 끝나야 메인으로 돌아감.
                    
                    alertView.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                })
            })
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in }
            
            alertView.addAction(shareAction)
            alertView.addAction(cancelAction)
            alertView.addAction(noShareAction)
            
            alertWindow(alertView: alertView)
            
        }
    }
    
    func alertWindow(alertView: UIAlertController){
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    func resizing(_ image: UIImage) -> Data?{
        
//        let imgData = UIImageJPEGRepresentation(image, 0.25)!
//        
//        let resizedImage = UIImage(data:imgData)
        
        let resizedWidthImage = image.resized(toWidth: 1080)
        
        let resizedData = UIImageJPEGRepresentation(resizedWidthImage!, 0.25)
        
        //let resizedData = UIImageJPEGRepresentation((image.resized(withPercentage: 0.5))!, 0.25)
        //UIImagePNGRepresentation((resizedImage?.resized(withPercentage: 0.5))!)
        
        return resizedData
        
    }
}
