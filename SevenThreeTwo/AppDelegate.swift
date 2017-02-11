//
//  AppDelegate.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 1. 18..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let userToken = UserDefaults.standard
    var apiManager : ApiManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // 앱이 백그라운드로 갈 때
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        let token = userToken.string(forKey: "token")
        if token != nil{
            self.apiManager = ApiManager(path: "/token", method: .get, parameters: [:], header: ["authorization":token!])
            self.apiManager.requestToken { (isToken) in
                if isToken != "OPEN_LOGINVC" {
                    self.userToken.set(isToken, forKey: "token")
                }else {
                    self.tokenInvalidAlert()
                }
            }
        }
        
        // 다시 들어올 때
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // 앱이 활성화 될 때
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    
    func tokenInvalidAlert(){
        let alertView = UIAlertController(title: "로그인 만료", message: "다시 로그인 해주세요.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginMainViewController")
            self.window?.rootViewController = loginVC
            self.window?.makeKeyAndVisible()
        
        })
        
        
        
        alertView.addAction(action)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    
}

