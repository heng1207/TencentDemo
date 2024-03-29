//
//  AppDelegate.swift
//  IMDemo
//
//  Created by 张恒 on 2019/5/29.
//  Copyright © 2019 张恒. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = ViewController()
        
        //IM用户在线状态通知
        NotificationCenter.default.addObserver(self, selector:#selector(onForceOffline(_ :)), name: NSNotification.Name(rawValue: TUIKitNotification_TIMUserStatusListener), object: nil)
        
        
        let sdkAppID = 1400097135
        let accType = "27768"
        let userID = "253"
        let userSig = "eJxFkNFugjAUht*FW5fR0haHiRdTMWNDI*gS0puG2cKOm9hBNaDZuw8JZJfn*3Lyn-PfrF24fUy1BilSI0gprYmFrIcOq1pDqUSaGVW22GGeg9AgL6qs4FTcOcIMOwShfwlSFQYy6PdIjyvI23nlR-NgefmR-BDMOH*RS8YXDY2bDEJiz6O6Aok3NW2U1GPfjp9hlrx9rpPD*lWN3t1rvNpgSvzKP6KMf*fhIudeEti7p48RO*fT6RAmv0T3WBuJaXubN8aE9dLAUd05Yx6jLnIHnu73p3NhhGm06pr4-QPcNFVG"
        
        //TUIKit初始化
        let config = TUIKitConfig.defaultConfig()
        TUIKit.sharedInstance().initKit(Int(sdkAppID), accountType: accType, with: (config as? TUIKitConfig))

        
        TUIKit.sharedInstance()?.loginKit(userID, userSig: userSig, succ: {
            print("登录成功")
        }, fail: { (code, errMsg) in
            print(errMsg as Any)
        })
        

    
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - TUIKitNotification_TIMUserStatusListener
    @objc func onForceOffline(_ noti:NSNotification) {
        let alertController = UIAlertController(title: "警告",message: "您的账号已过期或者在其他地方登陆", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确认", style: .default, handler: {
            action in
           
        })
        alertController.addAction(okAction)
        let rootVC = self.window!.rootViewController!
        rootVC.present(alertController, animated: true, completion: nil)
    }

}

