//
//  NotificationService.swift
//  RichPushNotifications
//
//  Created by Bas Buijsen on 15/11/2022.
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
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func saveImageAttachment(
      image: UIImage,
      forIdentifier identifier: String
    ) -> URL? {
      // 1
      let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
      // 2
      let directoryPath = tempDirectory.appendingPathComponent(
        ProcessInfo.processInfo.globallyUniqueString,
        isDirectory: true)

      do {
        // 3
        try FileManager.default.createDirectory(
          at: directoryPath,
          withIntermediateDirectories: true,
          attributes: nil)

        // 4
        let fileURL = directoryPath.appendingPathComponent(identifier)

        // 5
        guard let imageData = image.pngData() else {
          return nil
        }

        // 6
        try imageData.write(to: fileURL)
          return fileURL
        } catch {
          return nil
      }
    }


}
