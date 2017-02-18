//
//  DetailPictureViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 19..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class DetailPictureViewController: UIViewController , UIScrollViewDelegate{
    
    var receivedImg : UIImage!
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    let picImageView = UIImageView()
    var scrollImg: UIScrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        // Do any additional setup after loading the view.
        
        setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setUpView(){
        
        self.view.backgroundColor = UIColor.black
        
        let imageWidth = CGFloat(receivedImg.size.width)
        let imageHeight = CGFloat(receivedImg.size.height)
        
        
        if imageWidth == imageHeight {
            self.picImageView.frame = CGRect(x: 0*widthRatio, y: UIScreen.main.bounds.height/2 - (375*heightRatio)/2, width: 375*widthRatio, height: 375*heightRatio)
            
        }else{
            self.picImageView.frame = CGRect(x: 0*widthRatio, y: UIScreen.main.bounds.height/2 - (375*imageHeight/imageWidth)*heightRatio/2, width: 375*widthRatio, height: (375*imageHeight/imageWidth)*heightRatio)
        }
        
        picImageView.image = receivedImg
        
        let dismissRecognizer = UITapGestureRecognizer(target:self, action:#selector(cancelButtonAction))
        picImageView.isUserInteractionEnabled = true
        picImageView.addGestureRecognizer(dismissRecognizer)
        
        
        //self.view.addSubview(self.picImageView)
        
        
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        scrollImg.backgroundColor = UIColor.black
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.flashScrollIndicators()
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0
        
        self.view.addSubview(scrollImg)
        
        scrollImg.addSubview(picImageView)
    }
    
    func cancelButtonAction(){
        self.dismiss(animated: false, completion: nil)
    }
    

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.picImageView
    }
}
