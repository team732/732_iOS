//
//  ChangeCompleteViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 15..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class ChangeCompleteViewController: UIViewController {

    var receivedStatusMsg : Int!
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    var users = UserDefaults.standard
    var userToken : String!
    var apiManager : ApiManager!

    var checkImg : [UIImage] = [UIImage(named: "checkComplete1")!,UIImage(named:"checkComplete2")!,UIImage(named:"checkComplete3")!]
    var checkGif : UIImage!
    var checkImageView : UIImageView!
    var checkTimer = Timer()
    var checkSec : Float = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        userToken = users.string(forKey: "token")
        viewSetUp()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkTimer.invalidate()
        checkTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ChangeCompleteViewController.counter), userInfo: nil, repeats:true)
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
        
        
        let completeView = UIView(frame: CGRect(x: 58*widthRatio, y: 204*heightRatio, width: 260*widthRatio, height: 260*heightRatio))
        completeView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
        
        
        checkGif = UIImage.gifImageWithName(name: "checkComplete")
        checkImageView = UIImageView(image: checkGif)
        checkImageView.frame = CGRect(x: 260*widthRatio/2 - 29.5*widthRatio, y: 74*heightRatio, width: 59*widthRatio, height: 59*heightRatio)
        
        completeView.addSubview(checkImageView)
        
        let checkMsg = UIImageView()
        
        switch (receivedStatusMsg){
        case 0:
            checkMsg.frame = CGRect(x: 260*widthRatio/2 - 51.5*widthRatio, y: 162*heightRatio, width: 103*widthRatio, height: 37*heightRatio)
            checkMsg.image = self.checkImg[receivedStatusMsg]
            break
        case 1:
            checkMsg.frame = CGRect(x: 260*widthRatio/2 - 53.5*widthRatio, y: 162*heightRatio, width: 106*widthRatio, height: 37*heightRatio)
            checkMsg.image = self.checkImg[receivedStatusMsg]
            break
        case 2:
            checkMsg.frame = CGRect(x: 260*widthRatio/2 - 51.5*widthRatio, y: 162*heightRatio, width: 103*widthRatio, height: 37*heightRatio)
            checkMsg.image = self.checkImg[receivedStatusMsg]
            break
        default:
            break
        }
        completeView.addSubview(checkMsg)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(changeCompleteAction))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        self.view.addSubview(completeView)
        
    }
    
    func counter(){
        checkSec += 0.1
        if checkSec > 1.6 {
            self.checkImageView.removeFromSuperview()
            self.checkImageView = nil
            changeCompleteAction()
            checkTimer.invalidate()
        }
    }
    
    func changeCompleteAction(){
        self.performSegue(withIdentifier: "unwindToSetting", sender: self)
    }

}
