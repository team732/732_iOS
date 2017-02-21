//
//  AboutUsViewController
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 22..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        viewSetUp()
        
    }
    
    func viewSetUp(){
        
        self.view.backgroundColor = UIColor.clear
        
        let backView = UIView(frame: CGRect(x: 0*widthRatio, y: 0*heightRatio, width: 375*widthRatio, height: 667*heightRatio))
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.8
        self.view.addSubview(backView)
        
        
        let cancelBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - 11.5*widthRatio , y: 70*heightRatio, width: 23*widthRatio, height: 23*heightRatio))
        cancelBtn.setImage(UIImage(named: "cancelWhite"), for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        self.view.addSubview(cancelBtn)
        
        
        let aboutUsView = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width/2 - 139.5*widthRatio, y: 197*heightRatio, width: 279*widthRatio, height: 335*heightRatio))
        
        aboutUsView.image = UIImage(named: "aboutUs")
        
        
        self.view.addSubview(aboutUsView)
        
        let dismissExtension = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let dismissRecognizer = UITapGestureRecognizer(target:self, action:#selector(cancelButtonAction))
        dismissExtension.isUserInteractionEnabled = true
        dismissExtension.addGestureRecognizer(dismissRecognizer)
        self.view.addSubview(dismissExtension)

    }
    
    func cancelButtonAction(){
        self.dismiss(animated: false, completion: nil)
    }
    
}
