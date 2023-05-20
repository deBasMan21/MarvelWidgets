//
//  NotificationViewController.swift
//  McuWidgetsRPNContent
//
//  Created by Bas Buijsen on 20/05/2023.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SwiftUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    var hostingView: UIHostingController<NotificationView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        var projectId = -1
        if let url = userInfo["url"] as? String, let lastComponent = URL(string: url)?.lastPathComponent, let projId = Int(lastComponent) {
            projectId = projId
        }
        let title = notification.request.content.title
        let body = notification.request.content.body
        
        let notificationView: NotificationView
        if let data = UserDefaults(suiteName: "group.mcuwidgets")!.data(forKey: "imageData") {
            notificationView = NotificationView(img: UIImage(data: data), projectId: projectId, title: title, bodyText: body)
        } else {
            notificationView = NotificationView(img: nil, projectId: projectId, title: title, bodyText: body)
        }
        
        hostingView = UIHostingController(rootView: notificationView)

        self.view.addSubview(hostingView.view)
        hostingView.view.translatesAutoresizingMaskIntoConstraints = false

        hostingView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        hostingView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        hostingView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        hostingView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

}
