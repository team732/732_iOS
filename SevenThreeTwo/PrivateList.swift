//
//  PrivateList.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 15..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import SwiftyJSON

class PrivateList : NSObject{
    
    public var contentsCount : Int?
    public var contents : JSON?
    
    init(contentsCount: Int? , contents: JSON?){
        self.contentsCount = contentsCount
        self.contents = contents
    }
    
}
