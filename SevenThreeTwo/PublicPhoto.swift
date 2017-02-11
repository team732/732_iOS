//
//  Photo.swift
//  StackViewPhotoCollage
//
//  Created by Giancarlo on 7/4/15.
//  Copyright (c) 2015 Giancarlo. All rights reserved.
//

import UIKit



// Inspired by: RayWenderlich.com pinterest-basic-layout
class PublicPhoto: NSObject {
    
    var apiManager : ApiManager!
    var image: UIImage
    let userToken = UserDefaults.standard.string(forKey: "token")
    
    init(image: UIImage) {
        self.image = image
    }
    
    
    func allPhotos() -> [PublicPhoto] {
        
        loadContents()
        
        var photos = [PublicPhoto]()
        
        for i in 1..<10 {
            photos.append(PublicPhoto( image: UIImage(named: "otter-\(i).jpg")!))
        }
        return photos
    }
    
    func loadContents(){
        apiManager = ApiManager(path: "/contents", method: .get, parameters: [:], header: ["authorization":userToken!])
        apiManager.requestContents { (JSON) in
            print(JSON)
        }
    }
}
