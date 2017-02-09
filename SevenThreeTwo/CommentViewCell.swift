//
//  CommentViewCell.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 7..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {

    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0

    
    var nickLabel = UILabel()
    var dateLabel = UILabel()
    var commentLabel = UILabel()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
        nickLabel.frame = CGRect(x: 20*widthRatio, y: 18*heightRatio, width: 157*widthRatio, height: 14*heightRatio)
        nickLabel.font = UIFont(name: "Arita-dotum-SemiBold_OTF", size: 14*widthRatio)
        
        dateLabel.frame = CGRect(x: 248*widthRatio, y: 18*heightRatio, width: 67*widthRatio, height: 10*heightRatio)
        dateLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 10*widthRatio)
        
        commentLabel.frame.origin = CGPoint(x: 20*widthRatio, y: 42*heightRatio)
        commentLabel.frame.size.width = 295*widthRatio
        commentLabel.numberOfLines = 0
        commentLabel.font = UIFont(name: "Arita-dotum-Medium_OTF", size: 13*widthRatio)
 
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(nickLabel)
        contentView.addSubview(commentLabel)
    }
    
}
