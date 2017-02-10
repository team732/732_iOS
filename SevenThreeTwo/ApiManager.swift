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
    let url: String
    let method: HTTPMethod
    var parameters: Parameters
    let encoding = URLEncoding.default
    let header: HTTPHeaders
    
    init(path: String, method: HTTPMethod, parameters: Parameters = [:],header: HTTPHeaders) {
        url = server + path
        self.method = method
        self.parameters = parameters
        self.header = header
    }
    
    //completion:(String) -> Void (ex)
    func request(completion : @escaping (JSON)->Void){
        Alamofire.request(url,method: method,parameters: parameters).responseJSON{ response in
            //            let info = JSON(response.result.value!)
            //            completion(info)
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    //print(response.result.value!)
                    
                    let json = JSON(response.result.value!)
                    
                    //print(json)
                    //print(json["data"]["contents"][0].arrayValue)
                    
                    print(json["data"]["contents"].array!.count)
                    print(json["pagination"]["nextUrl"].string!)
                    
                    print(json["data"]["contents"][0]["contentId"].int!.description)
                    print(json["data"]["contents"][0]["content"]["picture"].string!)
                    print(json["data"]["contents"][0]["content"]["text"].string!)
                    print(json["data"]["contents"][0]["userId"].int!.description)
                    
                    print(json["data"]["contents"][0]["nickname"].string!)
                    print(json["data"]["contents"][0]["popularity"].int!.description)
                    print(json["data"]["contents"][0]["missionId"].int!.description)
                    print(json["data"]["contents"][0]["createdAt"].string!)
                    print(json["data"]["contents"][0]["likeCount"].int!.description)
                    print(json["data"]["contents"][0]["mission"]["text"].string!)
                    
                    
                }
                break
                
            case .failure(_):
                
                break
                
            }
        }
    }
    
    func requsetCheckDuplicated(completion : @escaping (JSON)->Void){
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
        print(url)
        print(method)
        print(parameters)
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
    
    
    /*
     사용 하는 컨트롤러에서
     
     apiManager.request() { (info) in
     print(info) -> info 는 JSON 형식 (@escaping 옆 () 안에 String 을 넣어주면 info 는 String으로 반환 단, completion안에도 String으로 넣어줘야함. 즉 이곳에서 내가 원하는 값으로 반환 받는것
     }
     */
    
}
