//
//  PastMissionPic.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 2. 15..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

// Inspired by: RayWenderlich.com pinterest-basic-layout
class PastMissionPic: NSObject {
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    static func allPhotos() -> [PastMissionPic] {
        var photos = [PastMissionPic]()
        for i in 1..<10 {
            photos.append(PastMissionPic( image: UIImage(named: "otter-\(i).jpg")!))
        }
        return photos
    }
}
