//
//  AppDelegate.swift
//  SevenThreeTwo
//
//  Created by 윤민섭 on 2017. 1. 18..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let users = UserDefaults.standard
    var apiManager : ApiManager!
    var userToken : String!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        userToken = users.string(forKey: "token")
        if userToken != nil{
            apiManager = ApiManager(path: "/missions/today", method: .get, header: ["authorization":userToken])
            apiManager.requestMissions(missionText: { (missionText) in
                MainController.missionText = missionText
            }) { (missionId) in
                MainController.missionId = missionId
            }
        }
        
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                if granted == true{
                    print("Allow")
                    UIApplication.shared.registerForRemoteNotifications()
                }else{
                    print("Don't Allow")
                }
            }
            
        } else {
            // Fallback on earlier version
            let notificationSettings = UIUserNotificationSettings(
                types: [.badge, .alert, .sound], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            
        }
        
        
        FIRApp.configure()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotificaiton), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        
        
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("%@", userInfo)
    }
    @objc fileprivate func tokenRefreshNotificaiton(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()!
        users.set(refreshedToken, forKey: "pushToken")
        print("InstanceID token: \(refreshedToken)")
        connectToFcm()
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    
    fileprivate func firebaseDisconnect(){
        FIRMessaging.messaging().disconnect()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // 앱이 백그라운드로 갈 때
        firebaseDisconnect()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        userToken = users.string(forKey: "token")
        if self.userToken != nil {
            self.apiManager = ApiManager(path: "/token", method: .get, parameters: [:], header: ["authorization":self.userToken!])
            self.apiManager.requestToken { (isToken) in
                if isToken != "OPEN_LOGINVC" {
                    self.users.set(isToken, forKey: "token")
                    self.apiManager = ApiManager(path: "/missions/today", method: .get, header: ["authorization":isToken])
                    self.apiManager.requestMissions(missionText: { (missionText) in
                        MainController.reEnterMain = 1
                        MainController.missionText = missionText
                    }) { (missionId) in
                        MainController.missionId = missionId
                    }
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

