//
//  AppDelegate.swift
//  Proximity Example
//
//  Created by Michael Kane on 4/21/18.
//  Copyright © 2018 Mike Kane. All rights reserved.
//

import UIKit
import  UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    
    let beaconManager = ESTBeaconManager()
    
    let iceUUID = "E1D2F683-10C9-45DB-8F8D-4FE32728849B"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        
        self.beaconManager.startMonitoring(for: CLBeaconRegion(
            proximityUUID: UUID(uuidString: iceUUID)!,
            major: 19845, minor: 23233, identifier: "monitored region"))
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        return true
    }
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        print("We entered the region!")
        showNotification(with: "Entered", body: "We entered  the region")
    }
    
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        print("Did exit region \(region)")
        showNotification(with: "Exit", body: "Did exit region")
    }
    
    func showNotification(with title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = 1
        content.sound = UNNotificationSound.default()
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "LocalNotification", content: content, trigger: timeTrigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("We have an error \(error)")
            }
        }
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

