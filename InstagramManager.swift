//
//  InstagramManager.swift
//  SevenThreeTwo
//
//  Created by 전한경 on 2017. 4. 24..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import Foundation
import Photos

class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let kInstagramURL = "instagram://app"
    private let kUTI = "com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    
    var documentInteractionController = UIDocumentInteractionController()
    
    // singleton manager
    class var sharedManager: InstagramManager {
        struct Singleton {
            static let instance = InstagramManager()
        }
        return Singleton.instance
    }
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView) {
        // called to post image with caption to the instagram application
        
        let instagramURL = NSURL(string: kInstagramURL)
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            
            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
            
            do{
                try UIImageJPEGRepresentation(imageInstagram, 1.0)!.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
            }catch{
                print(error)
            }
            let rect = CGRect(x: 0, y: 0, width: 612, height: 612)
            let fileURL = NSURL.fileURL(withPath: jpgPath)
            documentInteractionController.url = fileURL
            documentInteractionController.delegate = self
            documentInteractionController.uti = kUTI
            
            // adding caption for the image
            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
            documentInteractionController.presentOptionsMenu(from: rect, in: view, animated: true)
            //UIApplication.shared.openURL(instagramURL! as URL)//(instagramURL! as URL)
            
        } else {
            
            
            
            let alertView = UIAlertController(title: "오류", message: "인스타그램을 설치해주세요.", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            let alertWindow = UIWindow(frame: UIScreen.main.bounds)
            alertWindow.rootViewController = UIViewController()
            alertWindow.windowLevel = UIWindowLevelAlert + 1
            alertWindow.makeKeyAndVisible()
            alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
        }
    }
    
//    func postImageToInstagram(image: UIImage) {
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(InstagramManager.image(_:didFinishSavingWithError:contextInfo:)), nil)
//    }
//    func sendImageToInstagram(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
    
    
    func sendImageDirectlyToInstagram(image: UIImage) {
        
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        
//        if error != nil {
//            print(error)
//        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        
        if let lastAsset = fetchResult.firstObject {
            let localIdentifier = lastAsset.localIdentifier
            //let u = "instagram://library?LocalIdentifier=" + localIdentifier
            let u = "instagram://library?LocalIdentifier=" + localIdentifier
            
            let url = NSURL(string: u)!
            if UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(NSURL(string: u)! as URL)
            } else {
                
                
                let alertView = UIAlertController(title: "오류", message: "인스타그램을 설치해주세요.", preferredStyle: UIAlertControllerStyle.alert)
                alertView.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindowLevelAlert + 1
                alertWindow.makeKeyAndVisible()
                alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
                
            }
            
        }
    }
    
    
}
