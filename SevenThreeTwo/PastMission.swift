//
//  Mission.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 15..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class PastMission: NSObject {
    
    public var missionId : Int?
    public var mission : String?
    public var missionType : Int?
    public var missionDate : String?
    public var missionPic : UIImage?
    
    init(missionId: Int?, mission: String?, missionType: Int?, missionDate: String?, missionPic: UIImage?) {
        self.missionId = missionId
        self.mission = mission
        self.missionType = missionType
        self.missionDate = missionDate
        self.missionPic = missionPic
    }
    
    
    
    
}
