//
//  PastMissionCollectionViewCell.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 7..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class PastMissionCollectionViewCell: UICollectionViewCell {
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    // 기기의 너비와 높이
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var mission: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        
        self.makeItCircle()
        
    }
    
    func makeItCircle() {
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = (image.frame.width * widthRatio) / 2
        
      //image.clipsToBounds = false
        
    }
        }
