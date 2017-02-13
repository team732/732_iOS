//
//  Content.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 13..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import SwiftyJSON

class Content: NSObject{
    
    public var contentId : Int?
    public var contentPicture : String?
    public var contentText : String?
    public var userId : Int?
    public var nickname : String?
    public var isMine : Bool?
    public var isLiked : Int?
    public var replies : JSON?
    public var missionId : Int?
    public var createdAt : String?
    public var likeCount : Int?
    public var missionText : String?
    
    init(contentId: Int?, contentPicture: String?, contentText: String?, userId: Int?, nickname: String?, isMine: Bool?, isLiked: Int?, replies: JSON?, missionId: Int?, createdAt: String?, likeCount: Int?, missionText: String?) {
        self.contentId = contentId
        self.contentPicture = contentPicture
        self.contentText = contentText
        self.userId = userId
        self.nickname = nickname
        self.isMine = isMine
        self.isLiked = isLiked
        self.replies = replies
        self.missionId = missionId
        self.createdAt = createdAt
        self.likeCount = likeCount
        self.missionText = missionText
    }
    
   
}

/*
 "{
 ""meta"": {
 ""code"": 0,
 ""message"": ""success""
 },
 ""data"": {
 ""content"": {
 ""contentId"": ""Integer"",
 ""content"": ""JSON"",
 ""userId"": ""Integer"",
 ""missionId"": ""Integer,
 ""mission"": ""JSON"",
 ""createdAt"": ""Datetime(yyyy-mm-dd HH:ii:ss)"",
 ""nickname"": ""String"",
 ""likeCount"": Integer,
 ""isLiked"": Boolean,
 ""isMine"": Boolean,
 ""replies"": Array [
 {
 ""replyId"": ""Integer"",
 ""userId"": ""Integer"",
 ""nickname"": ""String"",
 ""reply"": ""JSON""
 }
 ]
 }
 }
 }"
 
 
*/
