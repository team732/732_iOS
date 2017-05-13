//
//  ShareViewController.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 5. 13..
//  Copyright © 2017년 윤민섭. All rights reserved.
//
//import Foundation
import UIKit



class SharingViewController: UIViewController {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    
    // 기기의 너비와 높이
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    var wholeView = UIView()
    var upperView = UIView()
    var shareLabel = UILabel()
    var logoView = UIImageView()
    
    var facebookImageView = UIImageView()
    var instaImageView = UIImageView()
    var facebookLabel = UILabel()
    var instaLabel = UILabel()
    
    var bottomLabel = UILabel()
    
    
    var line = UIView()
    var line2 = UIView()
    
    
    static var receivedImage = UIImage(named:"gotoleft")
    
    var finishFlag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        setView()
        
         //NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.removeWholeViews),name:NSNotification.Name(rawValue: "dismissCameraView"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setView(){
        
        wholeView.frame = CGRect(x: 0*widthRatio, y: 0*heightRatio, width: 375*widthRatio, height: 667*heightRatio)
        //wholeView.rframe(x: 0, y: 0, width: 375, height: 667)
        wholeView.backgroundColor = UIColor(red: 13/255, green: 13/255, blue: 13/255, alpha: 0.87)
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(blackViewAction))
//        wholeView.isUserInteractionEnabled = true
//        wholeView.addGestureRecognizer(tapGestureRecognizer)
//        
        
        upperView.frame = CGRect(x: 20*widthRatio, y: 113*heightRatio, width: 335*widthRatio, height: 321*heightRatio)

        upperView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.87)
        
        shareLabel.frame = CGRect(x: 149*widthRatio, y: 149*heightRatio, width: 79*widthRatio, height: 22*heightRatio)
        shareLabel.text = "공유하기"
        shareLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 22*widthRatio)
        shareLabel.textColor = UIColor(red: 67/255, green: 68/255, blue: 67/255, alpha: 1)
        
        
        line.frame = CGRect(x: 170*widthRatio, y: 193*heightRatio, width: 36*widthRatio, height: 1*heightRatio)
        
        line.backgroundColor = UIColor(red: 67/255, green: 68/255, blue: 67/255, alpha: 1)
        
        
        
        logoView.frame = CGRect(x: 96*widthRatio, y: 220*heightRatio, width: 184*widthRatio, height: 11*heightRatio)
        logoView.image = UIImage(named:"invalidName")
        
        line2.frame = CGRect(x: 186*widthRatio, y: 299*heightRatio, width: 0.5*widthRatio, height: 91*heightRatio)
        
        line2.backgroundColor = UIColor(red: 67/255, green: 68/255, blue: 67/255, alpha: 0.24)

        facebookImageView.frame = CGRect(x: 98*widthRatio, y: 310*heightRatio, width: 32*widthRatio, height: 32*heightRatio)
        
        facebookImageView.image = UIImage(named:"facebookImg")
        
        let facebook = UITapGestureRecognizer(target:self, action:#selector(facebookAction))
        facebookImageView.isUserInteractionEnabled = true
        facebookImageView.addGestureRecognizer(facebook)
        
        instaImageView.frame = CGRect(x: 245*widthRatio, y: 309*heightRatio, width: 32*widthRatio, height: 32*heightRatio)
        
        instaImageView.image = UIImage(named:"instaImg")
        
        let instagram = UITapGestureRecognizer(target:self, action:#selector(instaAction))
        instaImageView.isUserInteractionEnabled = true
        instaImageView.addGestureRecognizer(instagram)
        
        facebookLabel.frame = CGRect(x: 89*widthRatio, y: 364*heightRatio, width: 51*widthRatio, height: 17*heightRatio)
        facebookLabel.text = "페이스북"
        facebookLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 14*widthRatio)
        facebookLabel.textColor = UIColor(red: 67/255, green: 68/255, blue: 67/255, alpha: 1)
        
        instaLabel.frame = CGRect(x: 228*widthRatio, y: 364*heightRatio, width: 65*widthRatio, height: 17*heightRatio)
        instaLabel.text = "인스타그램"
        instaLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 14*widthRatio)
        instaLabel.textColor = UIColor(red: 67/255, green: 68/255, blue: 67/255, alpha: 1)
        
        bottomLabel.frame = CGRect(x: 106*widthRatio, y: 484*heightRatio, width: 164*widthRatio, height: 17*heightRatio)
        bottomLabel.text = "아니요, 그냥 게시하겠습니다"
        bottomLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 14*widthRatio)
        bottomLabel.textColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissAction))
        bottomLabel.isUserInteractionEnabled = true
        bottomLabel.addGestureRecognizer(tapGestureRecognizer)
        
        
        view.addSubview(wholeView)
        view.addSubview(upperView)
        
        view.addSubview(shareLabel)
        view.addSubview(line)
        view.addSubview(logoView)
        view.addSubview(line2)
        view.addSubview(facebookImageView)
        view.addSubview(instaImageView)
        view.addSubview(facebookLabel)
        view.addSubview(instaLabel)
        
        view.addSubview(bottomLabel)
        
    }
    func instaAction(){
        print("insta")

        //InstagramManager.sharedManager.postImageToInstagramWithCaption(imageInstagram: SharingViewController.receivedImage!, instagramCaption: "하하하하핳", view: self.view)
        
        InstagramManager.sharedManager.sendImageDirectlyToInstagram(image: SharingViewController.receivedImage!)
        //바로 앱으로연결될때만 가능...
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
        
    }
    func facebookAction(){
        print("face")
    }
    func dismissAction(){
        
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
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
