//
//  WaterMarkUtil.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 5. 4..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation
import UIKit

class WaterMarkUtil{
    
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    
    class var sharedUtil: WaterMarkUtil {
        struct Singleton {
            static let instance = WaterMarkUtil()
        }
        return Singleton.instance
    }
    
    func waterMarking(targetView:UIView, waterMarkImage:UIImage, completion :  (UIImage)->Void){
        
        
        let heightRatio = userDevice.userDeviceHeight()
        let widthRatio = userDevice.userDeviceWidth()
        
        let copiedView = targetView//.copyView()
        
        //1. targetView에 ImageView를 받아온 이미지로 init한다.
        let imageView = UIImageView.init(image: waterMarkImage)
        
        imageView.frame = CGRect(x:(targetView.frame.size.width - 65 * widthRatio),
                                 y:(targetView.frame.size.height - 42 * heightRatio),
                                 width: 55 * widthRatio,
                                 height: 32 * heightRatio)
        
        copiedView.addSubview(imageView)
        
        //2. targetVIew를 UIImage로 변환
        let wmImage = UIImage(view:copiedView)
        
        
        //3. return
        completion(wmImage)
        //return wmImage
    }
    
    
    
    
}

extension UIImage{
    convenience init(view: UIView) {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
}

extension UIView
{
    func copyView() -> UIView?
    {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView
    }
}
//이거쓰면 사진첩에들어가짐...
//extension UIImage {
//    convenience init(view: UIView) {
//        //UIGraphicsBeginImageContext(view.frame.size)
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.init(cgImage: (image?.cgImage)!)
//    }
//}
