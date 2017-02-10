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
        
        let copyRightImg = UIImageView(frame: CGRect(x: (156*widthRatio), y: (113*heightRatio), width: 64*widthRatio, height: 14*heightRatio))
        copyRightImg.image = UIImage(named: "copyright")
        copyRightImg.sizeToFit()
        self.view.addSubview(copyRightImg)
        
        drawRectangle(startX:47, startY: 195, width: 282, height:339)
        drawRectangle(startX: 52, startY: 201, width: 271, height: 327)

        
        let subscribeBtn = UIButton(frame: CGRect(x: 136*widthRatio , y: 258*heightRatio, width: 103*widthRatio, height: 18*heightRatio))
        subscribeBtn.addTarget(self, action: #selector(subscribeButtonAction), for: .touchUpInside)
        subscribeBtn.setTitle("받아보기 모음", for: .normal)
        subscribeBtn.setTitleColor(UIColor.black, for: .normal)
        subscribeBtn.titleLabel!.font =  UIFont(name: "Arita-dotum-Medium_OTF", size: 18*widthRatio)
        subscribeBtn.titleLabel!.font = subscribeBtn.titleLabel!.font.withSize(18*widthRatio)
        self.view.addSubview(subscribeBtn)
        
        drawLine(startX: 170, startY: 318, width: 36, height: 1, border: false, color: UIColor.black)
        
        let pastMissionBtn = UIButton(frame: CGRect(x: 145*widthRatio , y: 358*heightRatio, width: 87*widthRatio, height: 18*heightRatio))
        pastMissionBtn.addTarget(self, action: #selector(pastMissionButtonAction), for: .touchUpInside)
        pastMissionBtn.setTitle("과거 미션들", for: .normal)
        pastMissionBtn.setTitleColor(UIColor.black, for: .normal)
        pastMissionBtn.titleLabel!.font =  UIFont(name: "Arita-dotum-Medium_OTF", size: 18*widthRatio)
        pastMissionBtn.titleLabel!.font = pastMissionBtn.titleLabel!.font.withSize(18*widthRatio)

        self.view.addSubview(pastMissionBtn)
        
        drawLine(startX: 170, startY: 414 , width: 36, height: 1, border: false, color: UIColor.black)
        
        let hotPicBtn = UIButton(frame: CGRect(x: 144*widthRatio , y: 454*heightRatio, width: 88*widthRatio, height: 18*heightRatio))
        hotPicBtn.addTarget(self, action: #selector(hotPicButtonAction), for: .touchUpInside)
        hotPicBtn.setTitle("명예의 전당", for: .normal)
        hotPicBtn.setTitleColor(UIColor.black, for: .normal)
        hotPicBtn.titleLabel!.font =  UIFont(name: "Arita-dotum-Medium_OTF", size: 18*widthRatio)
        hotPicBtn.titleLabel!.font = hotPicBtn.titleLabel!.font.withSize(18*widthRatio)

        self.view.addSubview(hotPicBtn)
        
        
        let downBtn = UIImageView(frame: CGRect(x: (176*widthRatio), y: (600*heightRatio), width: 24*widthRatio, height: 24*heightRatio))
        downBtn.image = UIImage(named: "godown")
        downBtn.sizeToFit()
        self.view.addSubview(downBtn)
        
        
    }
    
    func subscribeButtonAction(){
        
    }
    
    func pastMissionButtonAction(){
        performSegue(withIdentifier: "pastToPast", sender: self)
    }
    
    func hotPicButtonAction(){
        performSegue(withIdentifier: "pastToHotpic", sender: self)
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
    
    func drawRectangle(startX: CGFloat,startY:CGFloat,width:CGFloat,height:CGFloat){
        drawLine(startX: startX, startY: startY, width: width, height: 1, border: false, color: UIColor.black)
        drawLine(startX: startX+width, startY: startY, width: 1, height: height, border: true, color: UIColor.black)
        drawLine(startX: startX+width, startY: startY+height, width: -width, height: 1, border: false, color: UIColor.black)
        drawLine(startX: startX, startY: startY+height, width: 1, height: -height, border: true, color: UIColor.black)
    }
    
    
}
