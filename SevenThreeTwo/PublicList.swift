//
//  PublicList.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 10..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

class PublicList: NSObject {
    
    public var contentId : Int?
    public var contentPicture : String?
    public var contentText : String?
    public var userId : Int?
    public var nickname : String?
    public var popularity : Int?
    public var missionId : Int?
    public var createdAt : String?
    public var likeCount : Int?
    public var missionText : String?
    
    init(contentId: Int?, contentPicture: String?, contentText: String?, userId: Int?, nickname: String?, popularity: Int?, missionId: Int?, createdAt: String?, likeCount: Int?, missionText: String?) {
        self.contentId = contentId
        self.contentPicture = contentPicture
        self.contentText = contentText
        self.userId = userId
        self.nickname = nickname
        self.popularity = popularity
        self.missionId = missionId
        self.createdAt = createdAt
        self.likeCount = likeCount
        self.missionText = missionText
    }
    
    
    
    
    
    
    
}
