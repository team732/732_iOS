//
//  PrivacyViewController.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 17..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var contents: UITextView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        borderView.frame = CGRect(x: (20*widthRatio), y: (40*heightRatio), width: 335*widthRatio, height: 607*heightRatio)
        borderView.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        borderView.layer.borderWidth = 1
        
        backBtn.frame = CGRect(x: (10*widthRatio), y: (50*heightRatio), width: 24*widthRatio, height: 24*heightRatio)
        backBtn.setImage(UIImage(named:"gotoleft"), for: .normal)
        backBtn.tintColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1.0)
        backBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        titleLabel.frame = CGRect(x: (53*widthRatio), y: (53*heightRatio), width: 229*widthRatio, height: 18*heightRatio)
        titleLabel.text = "개인정보 처리방침 및 이용약관"
        titleLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 18*widthRatio)
        titleLabel.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1.0)
        
        contents.frame = CGRect(x: (20*widthRatio), y: (109*heightRatio), width: 295*widthRatio, height: (476)*heightRatio)
        contents.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 14*widthRatio)
        contents.backgroundColor = UIColor.clear
        contents.textColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1.0)
        contents.isEditable = false
        contents.isSelectable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func backButtonAction(){
        dismiss(animated: true, completion: nil)
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
