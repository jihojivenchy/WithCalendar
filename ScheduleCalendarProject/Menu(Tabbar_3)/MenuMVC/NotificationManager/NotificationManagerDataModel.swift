//
//  NotificationManagerDataModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/05/19.
//

import Foundation
import UserNotifications

struct NotificationManagerDataModel {
    let center = UNUserNotificationCenter.current()
    
    var pendingRequests : [UNNotificationRequest] = []
    var customSubTitleArray : [String] = []
    
    func getAllNotificationIdentifiers(completion: @escaping ([UNNotificationRequest]) -> Void) {
        center.getPendingNotificationRequests { requests in
            completion(requests)
        }
    }
}
