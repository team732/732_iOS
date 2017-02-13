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

class ApiManager2 {
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
    func requestContents(pagination : @escaping (String)-> Void,completion : @escaping ([PublicList])->Void){
        
        Alamofire.request(url,method: method,parameters: parameters,encoding: encode, headers: header).responseJSON{ response in
            switch(response.result) {
                
            case .success(_):
                if let json = response.result.value{
                    let resp = JSON(json)
                    var publicList = [PublicList]()
                    let contents = resp["data"]["contents"]
                    for idx in 0..<contents.count {
                        let content = PublicList(contentId: contents[idx]["contentId"].intValue, contentPicture: contents[idx]["content"]["picture"].stringValue, contentText: contents[idx]["content"]["text"].stringValue, userId: contents[idx]["content"]["text"].intValue, nickname: contents[idx]["userId"].stringValue, popularity: contents[idx]["nickname"].intValue, missionId: contents[idx]["missionId"].intValue, createdAt: contents[idx]["createAt"].stringValue, likeCount: contents[idx]["lickCount"].intValue, missionText: contents[idx]["mission"]["text"].stringValue)
                        publicList += [content]
                    }
                    
                    pagination(resp["pagination"]["nextUrl"].stringValue)
                    completion(publicList)
                    
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
                    let infoContent = Content(contentId: detailContent["contentId"].intValue, contentPicture: detailContent["content"]["picture"].stringValue, contentText: detailContent["content"]["text"].stringValue, userId: detailContent["userId"].intValue, nickname: detailContent["nickname"].stringValue, isMine: detailContent["isMine"].boolValue, isLiked: detailContent["isLiked"].intValue, replies: detailContent["replies"], missionId: detailContent["missionId"].intValue, createdAt: detailContent["createdAt"].stringValue, likeCount: detailContent["likeCount"].intValue, missionText: detailContent["mission"]["text"].stringValue)
                    
                    
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
    
    /*
     사용 하는 컨트롤러에서
     
     apiManager.request() { (info) in
     print(info) -> info 는 JSON 형식 (@escaping 옆 () 안에 String 을 넣어주면 info 는 String으로 반환 단, completion안에도 String으로 넣어줘야함. 즉 이곳에서 내가 원하는 값으로 반환 받는것
     }
     */
    
}
