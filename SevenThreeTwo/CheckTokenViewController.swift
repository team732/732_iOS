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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        checkToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkToken(){
        let token = userToken.string(forKey: "token")
        if token != nil{
            print(token!)
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
