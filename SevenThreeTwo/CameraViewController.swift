//
//  CameraViewController.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 1. 23..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit


class CameraViewController: UIViewController {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    
    // 기기의 너비와 높이
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var inputText: UITextView!
    
    var receivedImg : UIImage = UIImage(named : "otter-3")!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        imageView.frame = CGRect(x: (0*widthRatio), y: (0*heightRatio), width: 375*widthRatio, height: (375*1.34)*heightRatio)
        
        backBtn.frame = CGRect(x: (30*widthRatio), y: (30*heightRatio), width: 18*widthRatio, height: 18*heightRatio)
        
        backBtn.setImage(UIImage(named:"backShadow"), for: .normal)
        backBtn.tintColor = UIColor.white
        backBtn.layer.shadowColor = UIColor.black.cgColor
        backBtn.layer.shadowRadius = 1
        backBtn.layer.shadowOffset =  CGSize(width: 0.0, height: 0.0)
        backBtn.layer.shadowOpacity = 1.0
        
        nextBtn.frame = CGRect(x: (312*widthRatio), y: (30*heightRatio), width: 33*widthRatio, height: 18*heightRatio)
        
        nextBtn.setImage(UIImage(named:"nextShadow"), for: .normal)
        nextBtn.tintColor = UIColor.white
        nextBtn.layer.shadowColor = UIColor.black.cgColor
        nextBtn.layer.shadowRadius = 1
        nextBtn.layer.shadowOffset =  CGSize(width: 0.0, height: 0.0)
        nextBtn.layer.shadowOpacity = 1.0
        
        inputText.frame = CGRect(x: (0*widthRatio), y: (440*heightRatio), width: 375*widthRatio, height: (227-59)*heightRatio)
        

        
        var line: UIView!
        
        
        line = UIView(frame: CGRect(x: 0*widthRatio, y: 606*heightRatio, width: 375*widthRatio, height: 0.5*heightRatio))
        
        line.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 68/255, alpha: 1.0)//UIColor.gray
        
        
        
        view.addSubview(line)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        
        imageView.image = receivedImg
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
