//
//  ApiManager.swift
//
//  Created by YOON on 2017. 2. 4..
//  Copyright © 2017년 MINSEOBYOON. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

private let server = "http://52.79.178.255"

class ApiManager {
    var url: String
    let method: HTTPMethod
    var parameters: Parameters
    let header: HTTPHeaders
    let encode = URLEncoding.default
    
    init(path: String, method: HTTPMethod, parameters: Parameters = [:],header: HTTPHeaders) {
        url = server + path
        self.method = method
        self.parameters = parameters
        self.header = header
    }
    
    //completion:(String) -> Void (ex)
    func requestContents(pagination : @escaping (String)-> Void,completion : @escaping (PublicList)->Void){
        
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    let content = PublicList(contentsCount: resp["data"]["contentsCount"].intValue, contents: resp["data"]["contents"])
                    
                    pagination(resp["pagination"]["nextUrl"].stringValue)
                    completion(content)
                    
                }
                break
                
            case .failure(_):
                break
                
            }
        }
    }
    
    func requestMyContents(pagination : @escaping (String)-> Void, completion : @escaping (PrivateList)->Void){
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { response in
            switch (response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    let content = PrivateList(contentsCount: resp["data"]["contentsCount"].intValue, contents: resp["data"]["contents"])
                    
                    pagination(resp["pagination"]["nextUrl"].stringValue)
                    completion(content)
                    
                }
                break
                
            case .failure(_):
                break
            }
        }
        
    }
    
    func requestContentLiked(completion : @escaping (Bool)->Void){
        Alamofire.request(url,method: method, headers: header).responseJSON { response in
            switch(response.result){
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    if resp["meta"]["code"].intValue == 0 {
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestSelectContent(completion : @escaping (Content)->Void){
        
        Alamofire.request(url, method: method, headers: header).responseJSON { response in
            switch(response.result){
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    let detailContent = resp["data"]["content"]
                    let infoContent = Content(contentId: detailContent["contentId"].intValue, contentPicture: detailContent["content"]["picture"].stringValue, contentText: detailContent["content"]["text"].stringValue, userId: detailContent["userId"].intValue, nickname: detailContent["nickname"].stringValue, isMine: detailContent["isMine"].boolValue, isLiked: detailContent["isLiked"].intValue, isPublic: detailContent["isPublic"].boolValue,replies: detailContent["replies"], missionId: detailContent["missionId"].intValue, createdAt: detailContent["createdAt"].stringValue, likeCount: detailContent["likeCount"].intValue, missionText: detailContent["mission"]["text"].stringValue, missionDate: detailContent["missionDate"].stringValue)
                    
                    
                    completion(infoContent)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestToken(completion : @escaping (String)->Void){
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    switch (resp["meta"]["code"].intValue){
                    case 0:
                        //토큰을 주고
                        completion(resp["data"]["token"].stringValue)
                        break
                    default:
                        //로그인으로
                        completion("OPEN_LOGINVC")
                        break
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requsetCheckDuplicated(completion : @escaping (JSON)->Void){
        
        url = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(url).responseJSON{ response in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestJoin(completion : @escaping (JSON)->Void){
        
        Alamofire.request(url, method: method, parameters: parameters).responseJSON{ response in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp)
                }
                break
            case .failure(_):
                break
                
            }
        }
    }
    
    
    func requestLogin(completion : @escaping (JSON)->Void){
        
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestUpload(imageData:Data, text:String, share:Bool, completion : @escaping (String)->Void){
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                multipartFormData.append(text.data(using: .utf8)!, withName: "text")
                multipartFormData.append(share.description.data(using: .utf8)!, withName: "isPublic")
                multipartFormData.append(imageData, withName: "photo",fileName: "default.jpeg", mimeType: "image/jpeg")
                
        },
            to: url,
            headers:header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        let resp = JSON(response.result.value!)
                        
                        completion(resp["meta"]["code"].stringValue)
                        
                        
                        
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        
        
        
    }
    
    func requestWriteComment(completion : @escaping (Int)->Void){
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { response in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp["meta"]["code"].intValue)
                }
                break
            case .failure(_):
                break
            }
            
        }
    }
    
    func requestRemoveComment(completion : @escaping (Int)->Void){
        Alamofire.request(url, method: method, encoding: encode, headers: header).responseJSON { response in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp["meta"]["code"].intValue)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestModifyComment(completion: @escaping (Int)->Void){
        Alamofire.request(url, method: method, parameters: parameters,encoding: encode, headers: header).responseJSON { response in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp["meta"]["code"].intValue)
                }
                break
            case .failure(_):
                break
            }
        }
        
    }
    
    //오늘의 미션
    func requestMissions(missionText: @escaping (String)->Void,missionId: @escaping (Int)->Void){
        Alamofire.request(url, method: method, parameters: parameters,encoding: encode, headers: header).responseJSON { response in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    missionText(resp["data"]["mission"]["mission"]["text"].stringValue)
                    missionId(resp["data"]["mission"]["missionId"].intValue)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func requestPastMissions(pagination : @escaping (String)-> Void,completion : @escaping ([PastMission])->Void){
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    var pastMission = [PastMission]()
                    let contents = resp["data"]["missions"]
                    
                    for idx in 0..<contents.count {
                        
                        let content = PastMission(missionId: contents[idx]["missionId"].intValue, mission: contents[idx]["mission"].stringValue, missionType: contents[idx]["missionType"].intValue, missionDate: contents[idx]["missionDate"].stringValue)
                        
                        pastMission += [content]
                    }
                    pagination(resp["pagination"]["nextUrl"].stringValue)
                    completion(pastMission)
                    
                }
                break
                
            case .failure(_):
                break
                
            }
        }
    }
    
    
    func requestSetInfo(completion : @escaping(Int)->Void){
        Alamofire.request(url, method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    print(resp)
                    completion(resp["meta"]["code"].intValue)
                }
            case .failure(_):
                break
            }
        }
        
    }
    
    func requestHotPic(hotPicSub : @escaping([String])->Void,hotPicCreator : @escaping([String])->Void,hotPicDate : @escaping([String])->Void,hotPicImg : @escaping([UIImage])->Void, hotPicContentId : @escaping([Int])->Void){
        Alamofire.request(url, method: method, parameters: parameters, encoding: encode, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    var hotpicArr : [UIImage] = []
                    var hotPicSubArr : [String] = []
                    var hotPicCreatorArr : [String] = []
                    var hotPicDateArr : [String] = []
                    var hotPicContentIdArr : [Int] = []
                    print(resp)
                    for idx in 0..<resp["data"]["contents"].count{
                        let hotPicUrl = resp["data"]["contents"][idx]["content"]["picture"].stringValue
                        let hotPicImg = UIImage(data: NSData(contentsOf: NSURL(string: hotPicUrl)! as URL)! as Data)!
                        hotpicArr.append(hotPicImg)
                        
                        let creator = resp["data"]["contents"][idx]["nickname"].stringValue
                        hotPicCreatorArr.append(creator)
                        
                        let subject = resp["data"]["contents"][idx]["mission"]["text"].stringValue
                        hotPicSubArr.append(subject)
                        
                        let date = resp["data"]["contents"][idx]["missionDate"].stringValue
                        hotPicDateArr.append(date)
                        
                        let contentId = resp["data"]["contents"][idx]["contentId"].intValue
                        hotPicContentIdArr.append(contentId)
                        
                    }
                    
                    hotPicImg(hotpicArr)
                    hotPicCreator(hotPicCreatorArr)
                    hotPicDate(hotPicDateArr)
                    hotPicSub(hotPicSubArr)
                    hotPicContentId(hotPicContentIdArr)
                }
            case .failure(_):
                break
            }
        }
    }
    
    //isPublic
    func requestPicLock(completion : @escaping(Int)->Void){
        print("here")
        Alamofire.request(url, method: method,headers: header).responseJSON { (response) in
            print(response.result)
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    print(resp)
                    completion(resp["meta"]["code"].intValue)
                }
            case .failure(_):
                print("failure")
                break
            }
        }
    }
    
    //find pw
    
    func requestFindPw(completion : @escaping(Int)->Void){
        Alamofire.request(url,method: method,parameters: parameters).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp["meta"]["code"].intValue)
                }
            case .failure(_):
                break
            }
        }
    }
    
    func requestUserInfo(completion : @escaping(Any)->Void){
        Alamofire.request(url,method: method,headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp["nickname"].description)
                }
            case .failure(_):
                break
            }
        }
    }
    
    func requestDeleteContent(completion : @escaping(Int)->Void){
        Alamofire.request(url,method: method, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    completion(resp["meta"]["code"].intValue)
                }
            case .failure(_):
                break
            }
        }
    }
    
    
    func requestPushToken(completion : @escaping(Int)->Void){
        
        Alamofire.request(url,method: method, parameters: parameters, encoding: encode ,headers: header).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if let json = response.result.value {
                    let resp = JSON(json)
                    print(resp)
                    completion(resp["meta"]["code"].intValue)
                }
            case .failure(_):
                print("failure")
                break
            }
        }
    }
    /*
     사용 하는 컨트롤러에서
     
     apiManager.request() { (info) in
     print(info) -> info 는 JSON 형식 (@escaping 옆 () 안에 String 을 넣어주면 info 는 String으로 반환 단, completion안에도 String으로 넣어줘야함. 즉 이곳에서 내가 원하는 값으로 반환 받는것
     }
     */
    
}
