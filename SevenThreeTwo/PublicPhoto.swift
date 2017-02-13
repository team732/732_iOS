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
    
    var image: UIImage
    var contentId : Int
    
    init(image: UIImage, contentId: Int) {
        self.image = image
        self.contentId = contentId
    }
    
   
}
