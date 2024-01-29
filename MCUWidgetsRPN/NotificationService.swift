//
//  NotificationService.swift
//  MCUWidgetsRPN
//
//  Created by Bas Buijsen on 16/11/2022.
//


import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            bestAttemptContent.categoryIdentifier = "myNotificationCategory"
            
            if let imageUrl = bestAttemptContent.userInfo["gcm.notification.imageUrl"] as? String {
                let imageUrl = imageUrl.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.w342)))
                downloadImage(from: imageUrl) { image in
                    if let attachment = UNNotificationAttachment.create(identifier: "temporaryNotificationImage", image: image, options: [:]) {
                        bestAttemptContent.attachments = [attachment]
                        contentHandler(bestAttemptContent)
                    } else {
                        contentHandler(bestAttemptContent)
                    }
                }
            } else if let fcmOptions = bestAttemptContent.userInfo["fcm_options"] as? [String: Any], let imageUrl = fcmOptions["image"] as? String {
                let imageUrl = imageUrl.replaceUrlPlaceholders(imageSize: ImageSize(size: .poster(.w342)))
                downloadImage(from: imageUrl) { image in
                    if let attachment = UNNotificationAttachment.create(identifier: "temporaryNotificationImage", image: image, options: [:]) {
                        bestAttemptContent.attachments = [attachment]
                        contentHandler(bestAttemptContent)
                    } else {
                        contentHandler(bestAttemptContent)
                    }
                }
            } else {
                contentHandler(bestAttemptContent)
            }
        } else {
            contentHandler(request.content)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    func downloadImage(from link: String, handler: @escaping (UIImage) -> Void) {
        guard let url = URL(string: link) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            UserDefaults(suiteName: "group.mcuwidgets")!.set(data, forKey: "imageData")
            UserDefaults(suiteName: "group.mcuwidgets")!.set("VALUE", forKey: "test")
            
            handler(image)
        }.resume()
    }
}
