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
    var photos = [PublicPhoto]()

    
    init(image: UIImage) {
        self.image = image
    }
    
   
    
    func loadContents() {
        
        apiManager = ApiManager(path: "/contents", method: .get, parameters: [:], header: ["authorization":userToken!])
        //        OperationQueue.main.addOperation(){
        self.apiManager.requestContents { (contentPhoto) in
            for i in 0..<contentPhoto.count{
                self.photos.append(PublicPhoto( image: UIImage(data: NSData(contentsOf: NSURL(string: contentPhoto[i].contentPicture!)! as URL)! as Data)!))
            }
        }
    }
}


/*
 func loadEx(){
 photos.append(PublicPhoto(image: UIImage(data: NSData(contentsOf: NSURL(string: )))))
 }*/

