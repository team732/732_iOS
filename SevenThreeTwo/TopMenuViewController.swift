//
//  TopViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 1. 19..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class TopMenuViewController: UIViewController {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()

        viewSetUp()

    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        let copyRightImg = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width/2 - (32*widthRatio), y: (113*heightRatio), width: 64*widthRatio, height: 11*heightRatio))
        copyRightImg.image = UIImage(named: "copyright")
        //copyRightImg.sizeToFit()
        self.view.addSubview(copyRightImg)
        
        let copyRightExtension = UIView(frame: CGRect(x: (UIScreen.main.bounds.width/2 - (42*widthRatio)), y: 103*heightRatio, width: 84*widthRatio, height: 31*heightRatio))
        copyRightExtension.backgroundColor = UIColor.clear
        let copyRecog = UITapGestureRecognizer(target:self, action:#selector(aboutUsButtonAction))
        copyRightExtension.isUserInteractionEnabled = true
        copyRightExtension.addGestureRecognizer(copyRecog)
        self.view.addSubview(copyRightExtension)

        
        
        drawRectangle(startX:47, startY: 195, width: 282, height:339)
        drawRectangle(startX: 52, startY: 200, width: 272, height: 329)

        
        let subscribeBtn = UIButton(frame: CGRect(x: 136*widthRatio , y: 258*heightRatio, width: 103*widthRatio, height: 18*heightRatio))
        subscribeBtn.addTarget(self, action: #selector(subscribeButtonAction), for: .touchUpInside)
        subscribeBtn.setTitle("받아보기 모음", for: .normal)
        subscribeBtn.setTitleColor(UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1), for: .normal)
        subscribeBtn.titleLabel!.font =  UIFont(name: "Arita-dotum-Medium_OTF", size: 18*widthRatio)
        self.view.addSubview(subscribeBtn)
        
        drawLine(startX: 170, startY: 318, width: 36, height: 1, border: false)
        
        let pastMissionBtn = UIButton(frame: CGRect(x: 0*widthRatio , y: 358*heightRatio, width: 375*widthRatio, height: 18*heightRatio))
        pastMissionBtn.addTarget(self, action: #selector(pastMissionButtonAction), for: .touchUpInside)
        pastMissionBtn.setTitle("지나간 잠상들", for: .normal)
        pastMissionBtn.setTitleColor(UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1), for: .normal)
        pastMissionBtn.titleLabel!.font =  UIFont(name: "Arita-dotum-Medium_OTF", size: 18*widthRatio)

        self.view.addSubview(pastMissionBtn)
        
        drawLine(startX: 170, startY: 414 , width: 36, height: 1, border: false)
        let hotPicBtn = UIButton(frame: CGRect(x: 144*widthRatio , y: 454*heightRatio, width: 88*widthRatio, height: 18*heightRatio))
        hotPicBtn.addTarget(self, action: #selector(hotPicButtonAction), for: .touchUpInside)
        hotPicBtn.setTitle("명예의 전당", for: .normal)
        hotPicBtn.setTitleColor(UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1), for: .normal)
        hotPicBtn.titleLabel!.font =  UIFont(name: "Arita-dotum-Medium_OTF", size: 18*widthRatio)

        self.view.addSubview(hotPicBtn)
        
        let downBtn = UIButton(frame: CGRect(x: (UIScreen.main.bounds.width/2 - (12*widthRatio)), y: (600*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        downBtn.setImage(UIImage(named: "godown"), for: .normal)
        //downBtn.sizeToFit()
        downBtn.addTarget(self, action: #selector(moveToMainVC), for: .touchUpInside)
        self.view.addSubview(downBtn)
        
        let moveExtension = UIView(frame: CGRect(x: (UIScreen.main.bounds.width/2 - (17*widthRatio)), y: 595*heightRatio, width: 34*widthRatio, height: 34*heightRatio))
        moveExtension.backgroundColor = UIColor.clear
        //moveExtension.layer.borderWidth = 1
        let moveRecog = UITapGestureRecognizer(target:self, action:#selector(moveToMainVC))
        moveExtension.isUserInteractionEnabled = true
        moveExtension.addGestureRecognizer(moveRecog)
        self.view.addSubview(moveExtension)
        
        
    }
    
    func subscribeButtonAction(){
        basicAlert(title: "준비중입니다!")
    }
    
    func pastMissionButtonAction(){
        performSegue(withIdentifier: "pastToPast", sender: self)
    }
    
    func hotPicButtonAction(){
        performSegue(withIdentifier: "pastToHotpic", sender: self)
    }
    
    func aboutUsButtonAction(){
        performSegue(withIdentifier: "pastToAboutUs", sender: self)
    }
    
    func drawLine(startX: CGFloat,startY: CGFloat,width: CGFloat, height: CGFloat, border:Bool){
        
        var line: UIView!
        
        if border{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width, height: height*heightRatio))
        }else{
            line = UIView(frame: CGRect(x: startX*widthRatio, y: startY*heightRatio, width: width*widthRatio, height: height))
        }
        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1)
        
        self.view.addSubview(line)
    }
    
    func drawRectangle(startX: CGFloat,startY:CGFloat,width:CGFloat,height:CGFloat){
        drawLine(startX: startX, startY: startY, width: width, height: 1, border: false)
        drawLine(startX: startX+width, startY: startY, width: 1, height: height+1, border: true)
        drawLine(startX: startX+width, startY: startY+height, width: -width, height: 1, border: false)
        drawLine(startX: startX, startY: startY+height, width: 1, height: -height, border: true)
    }
    
    func moveToMainVC(){
        CheckTokenViewController.snapContainer.moveToptoMiddle()
    }
    
    func basicAlert(title: String){
        let alertView = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
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
