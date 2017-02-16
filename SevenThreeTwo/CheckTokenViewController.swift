//
//  CheckTokenViewController.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 2. 11..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

class CheckTokenViewController: UIViewController {
    
    let userToken = UserDefaults.standard
    var apiManager : ApiManager!
    var launchTimer = Timer()
    var count = 0
    var launchSec = 0.0
    var imageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchGif = UIImage.gifImageWithName(name: "launchSplash")
        imageView = UIImageView(image: launchGif)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.view.addSubview(imageView)
        self.view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        launchTimer.invalidate()
        launchTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(CheckTokenViewController.counter), userInfo: nil, repeats:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 3.2초
    
    
    func counter(){
        launchSec += 0.1
        if launchSec > 3.5 {
            self.imageView.removeFromSuperview()
            self.imageView = nil
            checkToken()
            launchTimer.invalidate()
        }
    }
    
    func checkToken(){
        let token = userToken.string(forKey: "token")
        if token != nil{
            apiManager = ApiManager(path: "/token", method: .get, parameters: [:], header: ["authorization":token!])
            
            apiManager.requestToken { (isToken) in
                if isToken != "OPEN_LOGINVC" {
                    // 이곳에서 토큰 갱신
                    self.userToken.set(isToken, forKey: "token")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let left = storyboard.instantiateViewController(withIdentifier: "left")
                    let middle = storyboard.instantiateViewController(withIdentifier: "middle")
                    let right = storyboard.instantiateViewController(withIdentifier: "right")
                    let top = storyboard.instantiateViewController(withIdentifier: "top")
                    
                    let snapContainer = SnapContainerViewController.containerViewWith(left,
                                                                                      middleVC: middle,
                                                                                      rightVC: right,
                                                                                      topVC: top,
                                                                                      bottomVC: nil)
                    
                    self.present(snapContainer, animated: false, completion: nil)
                }else{
                    self.performSegue(withIdentifier: "tokenToLogin", sender: nil)
                }
            }
        } else{
            performSegue(withIdentifier: "tokenToLogin", sender: self)
        }
    }
    
    
    
    
}
