//
//  SettingTableViewCell.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 15..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    
    var infoLabel = UILabel()
    var rightImg = UIImageView()
    
    //switch
    override func awakeFromNib() {
        super.awakeFromNib()
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        infoLabel.frame = CGRect(x: 25*widthRatio, y: (487/10/2-8)*heightRatio, width: 178*widthRatio, height: 14*heightRatio)
        infoLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 14*widthRatio)
        
        
        rightImg.frame = CGRect(x: 272*widthRatio, y: (487/10/2-8)*heightRatio, width: 24*widthRatio, height: 24*heightRatio)
        rightImg.image = UIImage(named: "gotoright")
        rightImg.sizeToFit()
        
        
        
        
        
        contentView.addSubview(infoLabel)
        contentView.addSubview(rightImg)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
