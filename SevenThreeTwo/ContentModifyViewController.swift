//
//  ContentModifyViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 25..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class ContentModifyViewController: UIViewController , UITextViewDelegate{
    
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    var modiOkBtn = UIButton()
    var modiCancelBtn = UIButton()
    var modifyTextView = UITextView()
    var modifyView = UIView()
    var apiManager : ApiManager!
    var users = UserDefaults.standard
    var userToken : String!
    var selectedPic = UIImageView()
    
    
    var receivedText : String!
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        //사라질때 reload 라는 옵저버를 보낸다.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        self.modifyView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        modifyTextView.setKeyboardNotification(target: self.view)
        modifyView.frame = CGRect(x: 0, y: 100*heightRatio, width: 375*widthRatio, height: 567*heightRatio)
        selectedPic.image = SelectListViewController.receivedCimg
        let imageWidth = CGFloat((selectedPic.image?.size.width)!)
        let imageHeight = CGFloat((selectedPic.image?.size.height)!)
        
        
        if imageWidth > imageHeight {
            self.selectedPic.frame = CGRect(x: 20*widthRatio, y: 185*heightRatio-100*heightRatio, width: 335*widthRatio, height: (335*imageHeight/imageWidth)*heightRatio)
        }else if imageWidth < imageHeight{
            self.selectedPic.frame = CGRect(x: (modifyView.frame.width/2 - (350*imageWidth/imageHeight/2))*widthRatio, y: 152*heightRatio-100*heightRatio, width: (350*imageWidth/imageHeight)*widthRatio, height: 350*heightRatio)
        }else{
            self.selectedPic.frame = CGRect(x: 20*widthRatio, y: 159*heightRatio-100*heightRatio, width: 335*widthRatio, height: 335*heightRatio)
        }

        modifyView.addSubview(selectedPic)
        
        self.modiCancelBtn = UIButton(frame: CGRect(x: 30*widthRatio, y: 60*heightRatio, width: 32*widthRatio, height: 18*heightRatio))
        modiCancelBtn.setImage(UIImage(named: "modiconCancel"), for: .normal)
        modiCancelBtn.addTarget(self, action: #selector(modifyCancel), for: .touchUpInside)
        // add target
        
        self.view.addSubview(modiCancelBtn)
        
        self.modiOkBtn = UIButton(frame: CGRect(x: 311*widthRatio, y: 60*heightRatio, width: 34*widthRatio, height: 18*heightRatio))
        modiOkBtn.setImage(UIImage(named: "modiconOk"), for: .normal)
        modiOkBtn.addTarget(self, action: #selector(modifyOk), for: .touchUpInside)
        // add target
        
        self.view.addSubview(modiOkBtn)
        
        let line = drawLine(startX: 32*widthRatio, startY: selectedPic.frame.height+selectedPic.frame.origin.y + 24*heightRatio, width: 311*widthRatio, height: 1, border: false, color: UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1))
        
        modifyTextView.frame = CGRect(x: 40*widthRatio, y: line.frame.origin.y + 22*heightRatio, width: 295*widthRatio, height: UIScreen.main.bounds.height - line.frame.origin.y - 22*heightRatio)
        modifyTextView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        modifyTextView.setTextView(fontName: "Arita-dotum-Medium_OTF", size: 13)
        modifyTextView.delegate = self
        modifyTextView.text = receivedText
        
        self.modifyView.addSubview(line)
        self.modifyView.addSubview(modifyTextView)
        
        
        self.view.addSubview(modifyView)
        
    }
    
    func modifyCancel(){
        self.modifyTextView.removeObserver()
        self.view.removeFromSuperview()
        self.dismiss(animated: false, completion: nil)
    }
    
    func modifyOk(){

        apiManager = ApiManager(path: "/contents/\(SelectListViewController.receivedCid)/text", method: .put,parameters: ["text":modifyTextView.text], header: ["authorization":userToken])
        apiManager.requestModifyContent { (isModify) in
            if isModify == 0{
                self.modifyCancel()
            }
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        
        if(textView.text.characters.count < 141){
            
        }else{
            textviewRangeAlert(overMsg: true,message: "긴 설명은 좋지 않습니다.")
        }
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.endEditing(true)
            modifyTextView.setEmojiFlag()
            self.view.frame.origin.y = 0
            textView.resignFirstResponder()
        }
        return true
    }
    
    
    
    func textviewRangeAlert(overMsg : Bool,message: String){
        let alertView = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            if overMsg{
                while(self.modifyTextView.text.characters.count > 140){
                    self.modifyTextView.text.characters.removeLast()
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

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
