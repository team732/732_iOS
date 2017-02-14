//
//  SettingViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 14..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0

    var settingLabel : UIImageView!
    var backBtn : UIButton!
    
    
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
        
        //settingLabel
        settingLabel = UIImageView(frame: CGRect(x: 167.5*widthRatio, y: 90*heightRatio, width: 40*widthRatio, height: 22*heightRatio))
        settingLabel.image = UIImage(named: "settingLabel")
        settingLabel.sizeToFit()
        self.view.addSubview(settingLabel)
        
        //gotoleft
        backBtn = UIButton(frame: CGRect(x: 30*widthRatio, y: 87*heightRatio, width: 24*widthRatio, height: 24*heightRatio))
        backBtn.setImage(UIImage(named: "gotoleft"), for: .normal)
        backBtn.addTarget(self, action: #selector(SettingViewController.backButtonAction), for: .touchUpInside)
        backBtn.sizeToFit()
        self.view.addSubview(backBtn)
        
        setDraw()
        
        
        
        
        
     
        
    }
    
    func backButtonAction(){
        self.dismiss(animated: true, completion: nil)
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
    
    func setDraw(){
        drawRectangle(startX: 20, startY: 160, width: 335, height: 487)
        drawLine(startX: 32, startY: 208, width: 311, height: 1, border: false, color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.25))
        drawLine(startX: 32, startY: 250, width: 311, height: 1, border: false, color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.25))
        drawLine(startX: 32, startY: 292, width: 311, height: 1, border: false, color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.25))
        
        drawLine(startX: 32, startY: 334, width: 311, height: 1, border: false, color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.25))
        
        drawLine(startX: 32, startY: 376, width: 311, height: 1, border: false, color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.25))
        
        drawLine(startX: 32, startY: 436, width: 311, height: 1, border: false, color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.25))
        drawLine(startX: 32, startY: 478, width: 311, height: 1, border: false, color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.25))
        
        drawLine(startX: 32, startY: 520, width: 311, height: 1, border: false, color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.25))
        
        drawLine(startX: 32, startY: 562, width: 311, height: 1, border: false, color: UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 0.25))

    }


   
}
