//
//  AppDelegate.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 15/11/2022.
//

import Foundation

import UIKit
import UserNotifications
import Firebase
import FirebaseDynamicLinks
import FirebaseMessaging
import FirebaseRemoteConfig

class AppDelegate: UIResponder, UIApplicationDelegate, Observable {
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    var shouldShowNotification = false
    var notificationUserData: [String: Any] = [:]
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        if UserDefaults.standard.string(forKey: "first") == nil {
            UserDefaults.standard.set("true", forKey: "first")
        }
        
        return true
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        notifyView(userInfo: userInfo, inApp: false)
        
        // Print full message.
        print(userInfo)
    }
    
    // [START receive_message]
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult)
                     -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        notifyView(userInfo: userInfo, inApp: false)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // [END receive_message]
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // [START_EXCLUDE]
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // Print full message.
        print(userInfo)
        notifyView(userInfo: userInfo, inApp: true)
        
        // Change this to your preferred presentation option
        completionHandler([[.badge, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // [START_EXCLUDE]
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // [END_EXCLUDE]
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        print(userInfo)
        notifyView(userInfo: userInfo, inApp: false)
        
        completionHandler()
    }
}

// [END ios_10_message_handling]
extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // [END refresh_token]
}

extension AppDelegate {
    func notifyView(userInfo: [AnyHashable: Any], inApp: Bool) {
        if let url = userInfo["url"], let aps = userInfo["aps"] as? [AnyHashable: Any], let alert = aps["alert"] as? [AnyHashable: Any], let title = alert["title"] {
            let userInfo = ["url": url, "inApp": inApp, "title": title, "body": alert["body"] as Any]
            self.notificationUserData = userInfo
            self.shouldShowNotification = true
            NotificationCenter.default.post(name: Notification.Name("url"), object: nil, userInfo: userInfo)
        }
    }
}
