//
//  PrivateList.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 15..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class PrivatePhoto : NSObject{
    
    public var image: UIImage
    public var contentId : Int
    
    init(image: UIImage, contentId: Int) {
        self.image = image
        self.contentId = contentId
    }
}
