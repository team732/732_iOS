//
//  Photo.swift
//  StackViewPhotoCollage
//
//  Created by Giancarlo on 7/4/15.
//  Copyright (c) 2015 Giancarlo. All rights reserved.
//

import UIKit



// Inspired by: RayWenderlich.com pinterest-basic-layout
class PrivatePhoto: NSObject {
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    static func allPhotos() -> [PrivatePhoto] {
        var photos = [PrivatePhoto]()
        for i in 1..<10 {
            photos.append(PrivatePhoto( image: UIImage(named: "otter-\(i).jpg")!))
        }
        return photos
    }
}
