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
    
    var receivedImg : UIImage = UIImage(named : "otter-3")!

    var apiManager : ApiManager!
    let userToken = UserDefaults.standard
    
    let placeHolderText : String = "140자 이내로 작성해주세요."
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        heightRatio = userDevice.userDeviceHeight()
        
        widthRatio = userDevice.userDeviceWidth()
        
        view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        imageView.frame = CGRect(x: (0*widthRatio), y: (0*heightRatio), width: 375*widthRatio, height: (500)*heightRatio)
        
        backBtn.frame = CGRect(x: (30*widthRatio), y: (30*heightRatio), width: 18*widthRatio, height: 18*heightRatio)
        
        backBtn.setImage(UIImage(named:"backShadow"), for: .normal)
        backBtn.tintColor = UIColor.white
        backBtn.layer.shadowColor = UIColor.black.cgColor
        backBtn.layer.shadowRadius = 1
        backBtn.layer.shadowOffset =  CGSize(width: 0.0, height: 0.0)
        backBtn.layer.shadowOpacity = 1.0
        
        nextBtn.frame = CGRect(x: (312*widthRatio), y: (30*heightRatio), width: 33*widthRatio, height: 18*heightRatio)
        
        nextBtn.setImage(UIImage(named:"share"), for: .normal)
        nextBtn.tintColor = UIColor.white
        nextBtn.layer.shadowColor = UIColor.black.cgColor
        nextBtn.layer.shadowRadius = 1
        nextBtn.layer.shadowOffset =  CGSize(width: 0.0, height: 0.0)
        nextBtn.layer.shadowOpacity = 1.0
        
        inputText.frame = CGRect(x: (16*widthRatio), y: (516*heightRatio), width: 343*widthRatio, height: (106)*heightRatio)
        inputText.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
        inputText.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        inputText.textColor = UIColor.gray//UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        inputText.text = placeHolderText

        
        var line: UIView!
        
        
        line = UIView(frame: CGRect(x: 0*widthRatio, y: 622*heightRatio, width: 375*widthRatio, height: 0.5*heightRatio))
        
        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1.0)//UIColor.gray
        
        
        
        view.addSubview(line)
        
        // 키패드에게 알림을 줘서 키보드가 보여질 때 사라질 때의 함수를 실행시킨다
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?) {
        inputText.endEditing(true) // textBox는 textFiled 오브젝트 outlet 연동할때의 이름.
        //self.bottomConstraint.constant = 0
    }
    // 키보드가 보여지면..
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    // 키보드가 사라지면..
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
        
    }
    
    // 높이를 조정한다 ..
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            
            self.view.frame.origin.y += changeInHeight
            
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
            
            let alertView = UIAlertController(title: "", message: "공유 여부를 선택해주세요.", preferredStyle: .alert)
            
            let shareAction = UIAlertAction(title: "공유하기", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
                print("공유하기")
                self.apiManager = ApiManager(path: "/missions/1/contents", method: .post, parameters: [:], header: ["authorization":token!])
                
                self.apiManager.requestUpload(imageData: self.resizing(self.receivedImg)!, text: self.inputText.text, share:true, completion: { (result) in
                    
                                print("resultCode : \(result)")
                                //서버 통신이 끝나야 메인으로 돌아감.
                    
                                alertView.dismiss(animated: true, completion: nil)
                                self.dismiss(animated: true, completion: nil)
                            })
                
                
                
            })
            
            let noShareAction = UIAlertAction(title: "나만보기", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
                print("나만보기")
                alertView.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
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
        var resizedData: NSData? = nil
        let imgData: NSData = UIImagePNGRepresentation(image)! as NSData
        
        print("imgData.length : \(imgData.length)")
        
        if imgData.length > 200000{
            print("aaaa")
            let resizedImage = image.resized(withPercentage: 0.5)
            
            resizedData = UIImagePNGRepresentation(resizedImage!)! as NSData
            
            if (resizedData?.length)! > 200000{
                print("bbb")
                return resizing(resizedImage!)
                
            }
            
        }
        
        print("img size :\(imgData.length)")
        print("resizedImg size :\(resizedData?.length)")
        return imgData as Data
        
    }
}
