//
//  AppDelegate.swift
//  Petopia
//
//  Created by Michelle Swastika on 29/05/24.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    let coba : uiview
    let game = GameViewController()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Minta izin untuk notifikasi
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        print("Notification permission granted.")
                    } else {
                        print("Notification permission denied.")
                    }
                }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        scheduleNotification()
        print((GameViewController.scene!.pet!.hungerLevel))
        print((GameViewController.scene!.pet!.thirstLevel))
        checkLevelsAndScheduleNotifications(hungerLevel: (GameViewController.scene?.pet!.hungerLevel)!, thirstLevel: (GameViewController.scene?.pet!.thirstLevel)!)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
//    var https://developer.apple.com/documentation/usernotifications/untimeintervalnotificationtrigger
    
  
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Hunger Level: \(String(describing: (GameViewController.scene!.pet!.hungerLevel) <= 30))"
        content.body = "Don't forget to check on your \( GameViewController.scene!.pet!.name)!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // Notifikasi setelah 5 menit
//        let petEntity = PetEntity.shared
       
//        petEntity
        let request = UNNotificationRequest(identifier: "PetNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled")
            }
        }
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Tampilkan notifikasi ketika aplikasi aktif
        completionHandler([.banner, .badge, .sound])
    }
}

func scheduleNotificationWhenLevelReachesThreshold(currentLevel: Int, ratePerMinute: Int, threshold: Int, type: String) {
    var minutesUntilThreshold = 0.0
    if (currentLevel >= threshold){
        minutesUntilThreshold = Double((currentLevel - threshold) / ratePerMinute)
    }
    if minutesUntilThreshold <= 0 {
        minutesUntilThreshold = 0.001
    }
    print(minutesUntilThreshold)
    if minutesUntilThreshold > 0 {
//        print(minutesUntilThreshold)
        let content = UNMutableNotificationContent()
        content.title = "\(type) Level Alert!"
        content.body = "Your pet's \(type.lowercased()) level has dropped below \(threshold)."
        content.sound = UNNotificationSound.default

        // Jadwalkan notifikasi untuk dikirim setelah `minutesUntilThreshold` menit
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(minutesUntilThreshold * 60), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(type) Level below \(threshold) in \(minutesUntilThreshold) minute(s).")
            }
        }
    }
}

func checkLevelsAndScheduleNotifications(hungerLevel: Int, thirstLevel: Int) {
    
    if hungerLevel < 50 {
        scheduleNotificationWhenLevelReachesThreshold(currentLevel: hungerLevel, ratePerMinute: 10, threshold: 25, type: "Hunger")
    }
    else{
        scheduleNotificationWhenLevelReachesThreshold(currentLevel: hungerLevel, ratePerMinute: 10, threshold: 50, type: "Hunger")
    }
    
    if thirstLevel < 50 {
        scheduleNotificationWhenLevelReachesThreshold(currentLevel: thirstLevel, ratePerMinute: 10, threshold: 25, type: "Thirst")
    }
    else{
        scheduleNotificationWhenLevelReachesThreshold(currentLevel: thirstLevel, ratePerMinute: 10, threshold: 50, type: "Thirst")
    }
    
}

