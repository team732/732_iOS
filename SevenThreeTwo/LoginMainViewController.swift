//
//  LoginMainViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 2..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class LoginMainViewController: UIViewController {

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0

    
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
        
        
        let logoLandScape = UIImageView(frame: CGRect(x: (160*widthRatio), y: (91*heightRatio), width: 63*widthRatio, height: 43*heightRatio))
        logoLandScape.image = UIImage(named: "logoLandScape")
        self.view.addSubview(logoLandScape)
     
        drawLine(startX: 187, startY: 134, width: 1, height: 61, border: true, color: UIColor.black)
        
        drawLine(startX: 0, startY: 355, width: 58, height: 1, border: false, color: UIColor.black)
        
        drawLine(startX: 319, startY: 355, width: 56, height: 1, border: false, color: UIColor.black)
        
        drawLine(startX: 186, startY: 500, width: 1, height: 113, border: true, color: UIColor.black)
        
        let mainLogo = UIImageView(frame: CGRect(x: (114*widthRatio), y: (206*heightRatio), width: 147*widthRatio, height: 15*heightRatio))
        mainLogo.image = UIImage(named: "mainLogo")
        self.view.addSubview(mainLogo)
        
        let loginBtn = UIButton(frame: CGRect(x: 72*widthRatio , y: 365*heightRatio, width: 232*widthRatio, height: 51*heightRatio))
        loginBtn.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        loginBtn.setImage(UIImage(named:"login"), for: .normal)
        self.view.addSubview(loginBtn)
        
        let joinBtn = UIButton(frame: CGRect(x: 72*widthRatio , y: 294*heightRatio, width: 232*widthRatio, height: 51*heightRatio))
        joinBtn.addTarget(self, action: #selector(joinButtonAction), for: .touchUpInside)
        joinBtn.setImage(UIImage(named:"join"), for: .normal)
        self.view.addSubview(joinBtn)
        
    }
    
    func loginButtonAction(){
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let left = storyboard.instantiateViewController(withIdentifier: "left")
        let middle = storyboard.instantiateViewController(withIdentifier: "middle")
        let right = storyboard.instantiateViewController(withIdentifier: "right")
        let top = storyboard.instantiateViewController(withIdentifier: "top")
        
        let snapContainer = SnapContainerViewController.containerViewWith(left,
                                                                          middleVC: middle,
                                                                          rightVC: right,
                                                                          topVC: top,
                                                                          bottomVC: nil)
       
        // 로그인 서버에서 시켜라~
        self.present(snapContainer, animated: true, completion: nil)

    }
    func joinButtonAction(){
        self.performSegue(withIdentifier: "joinToId", sender: self)
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

    
    

 

}
