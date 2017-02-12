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
    
   
}
