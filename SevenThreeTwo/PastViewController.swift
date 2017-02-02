//
//  TopViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 1. 19..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class PastViewController: UIViewController {
    
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
        
        let copyRightImg = UIImageView(frame: CGRect(x: (156*widthRatio), y: (90*heightRatio), width: 64*widthRatio, height: 14*heightRatio))
        copyRightImg.image = UIImage(named: "copyright")
        self.view.addSubview(copyRightImg)
        
        drawRectangle(startX: 52, startY: 154, width: 271, height: 327)

        
        let subscribeBtn = UIButton(frame: CGRect(x: 137*widthRatio , y: 211*heightRatio, width: 103*widthRatio, height: 18*heightRatio))
        subscribeBtn.addTarget(self, action: #selector(subscribeButtonAction), for: .touchUpInside)
        subscribeBtn.setTitle("받아보기 모음", for: .normal)
        subscribeBtn.setTitleColor(UIColor.black, for: .normal)
        subscribeBtn.titleLabel!.font =  UIFont(name: "아리따-돋움(OTF)-Medium", size: 18*widthRatio)
        subscribeBtn.titleLabel!.font = subscribeBtn.titleLabel!.font.withSize(18*widthRatio)
        self.view.addSubview(subscribeBtn)
        
        drawLine(startX: 170, startY: 271, width: 36, height: 1, border: false, color: UIColor.black)
        
        let pastMissionBtn = UIButton(frame: CGRect(x: 145*widthRatio , y: 311*heightRatio, width: 87*widthRatio, height: 18*heightRatio))
        pastMissionBtn.addTarget(self, action: #selector(pastMissionButtonAction), for: .touchUpInside)
        pastMissionBtn.setTitle("과거 미션들", for: .normal)
        pastMissionBtn.setTitleColor(UIColor.black, for: .normal)
        pastMissionBtn.titleLabel!.font =  UIFont(name: "아리따-돋움(OTF)-Medium", size: 18*widthRatio)
        pastMissionBtn.titleLabel!.font = pastMissionBtn.titleLabel!.font.withSize(18*widthRatio)

        self.view.addSubview(pastMissionBtn)
        
        drawLine(startX: 170, startY: 367 , width: 36, height: 1, border: false, color: UIColor.black)
        
        let hotPicBtn = UIButton(frame: CGRect(x: 145*widthRatio , y: 407*heightRatio, width: 88*widthRatio, height: 18*heightRatio))
        hotPicBtn.addTarget(self, action: #selector(hotPicButtonAction), for: .touchUpInside)
        hotPicBtn.setTitle("명예의 전당", for: .normal)
        hotPicBtn.setTitleColor(UIColor.black, for: .normal)
        hotPicBtn.titleLabel!.font =  UIFont(name: "아리따-돋움(OTF)-Medium", size: 18*widthRatio)
        hotPicBtn.titleLabel!.font = hotPicBtn.titleLabel!.font.withSize(18*widthRatio)

        self.view.addSubview(hotPicBtn)
        
        let mainLogo = UIImageView(frame: CGRect(x: (117*widthRatio), y: (539*heightRatio), width: 142*widthRatio, height: 15*heightRatio))
        mainLogo.image = UIImage(named: "mainLogo")
        self.view.addSubview(mainLogo)
        
        let logoLandScape = UIImageView(frame: CGRect(x: (145*widthRatio), y: (570*heightRatio), width: 90*widthRatio, height: 61*heightRatio))
        logoLandScape.image = UIImage(named: "logoLandScape")
        self.view.addSubview(logoLandScape)
        
        
        let oneRec = UIImageView(frame: CGRect(x: (32*widthRatio), y: (631*heightRatio), width: 12*widthRatio, height: 12*heightRatio))
        oneRec.image = UIImage(named: "Rec1")
        self.view.addSubview(oneRec)
        
        let twoRec = UIImageView(frame: CGRect(x: (331*widthRatio), y: (631*heightRatio), width: 12*widthRatio, height: 12*heightRatio))
        twoRec.image = UIImage(named: "Rec2")
        self.view.addSubview(twoRec)
  
        
        
    }
    
    func subscribeButtonAction(){
        
    }
    
    func pastMissionButtonAction(){
        
    }
    
    func hotPicButtonAction(){
        
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
