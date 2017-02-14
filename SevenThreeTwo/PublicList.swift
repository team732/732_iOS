//
//  PublicList.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 10..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import SwiftyJSON

class PublicList: NSObject {
    
    public var contentsCount : Int?
    public var contents : JSON?
    
    init(contentsCount: Int? , contents: JSON?){
        self.contentsCount = contentsCount
        self.contents = contents
    }
    
    
    
}
