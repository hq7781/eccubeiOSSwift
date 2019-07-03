//
//  AppDelegate.swift
//  eccube
//
//  Created by 洪 権 on 2019/07/02.
//  Copyright © 2019 hq7781@gmail.com. All rights reserved.
//

import UIKit
//import AppiariesSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.regRemoteNotification()
        self.checkRemoteNotification(launchOptions: launchOptions)
        self.setStartUpWindow()
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
}

// MARK - private methods
extension AppDelegate {
    func regRemoteNotification() {
        if  #available(iOS 10.0, *) {
            // TODO::
        } else  {
            let types : UIUserNotificationType = UIUserNotificationType(rawValue: UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue)
            let notifSettings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifSettings)
        }
    }
    
    func checkRemoteNotification(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let userInfo : NSDictionary = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary else {
            print("have not remote notification Key")
            return
        }
        self.handlePushIfNeeded(userInfo:userInfo)
    }
    
    func setStartUpWindow() {
        let tabBarController = UITabBarController()
        let homeVc = self.initialWebViewController(path:"/",iconTitle:"Home",iconImageName:"tab_home")
        let userVc = self.initialWebViewController(path:"/mypage",iconTitle:"マイページ",iconImageName:"tab_user")
        let listVc = self.initialWebViewController(path:"/products/list",iconTitle:"商品一覧",iconImageName:"tab_list")
        let cartVc = self.initialWebViewController(path:"/cart",iconTitle:"カート",iconImageName:"tab_cart")
        let favoVc = self.initialWebViewController(path:"/mypage/favorite",iconTitle:"お気に入り",iconImageName:"tab_favorite")
        tabBarController.viewControllers = [homeVc,listVc,cartVc,favoVc,userVc]
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = tabBarController
    }
}

extension AppDelegate {
    private func initialWebViewController(path: String, iconTitle: String, iconImageName: String) -> WebViewController{
        let vc = WebViewController()
        vc.initialPath = path
        vc.tabBarItem = UITabBarItem(title: iconTitle, image: UIImage(named: iconImageName), selectedImage: UIImage(named: "\(iconImageName)_on"))
        return vc
    }
    
    private func handlePushIfNeeded(userInfo: NSDictionary) {
        guard let aps = userInfo["aps"] as? NSDictionary else {
            print("have not aps")
            return
        }
        print("getted aps info: \(aps)")
        if  #available(iOS 10.0, *) {
            // TODO::
        } else  {
            UIApplication.shared.applicationIconBadgeNumber = 0
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
}
