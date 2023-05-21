//
//  AddScheduleNotificationService.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/26.
//

import Foundation
import UserNotifications

struct NotificationService {
    let center = UNUserNotificationCenter.current()
    
    func setNotificationRequest(data: AddScheduleData) {
        
        //contents 생성.
        let notificationContent = createNotificationContent(data: data)
        
        //trigger 생성. 언제 알림이 울릴지 예약.
        let notificationTrigger = createNotificationTrigger(data: data)
        
        let request = UNNotificationRequest(identifier: data.title,
                                            content: notificationContent,
                                            trigger: notificationTrigger)
    
        center.add(request) { error in
            if let e = error {
                print("Error 노티피케이션 설정 실패 : \(e)")
            }else{
                print("Success")
            }
        }
    }
    
    //content 설정.
    //1. title = 이벤트 제목
    //2. subTitle = 이벤트 시작날짜 ~ 종료날짜
    //3. body = notification 설정 옵션.
    func createNotificationContent(data: AddScheduleData) -> UNMutableNotificationContent {
        
        //content 생성, 메세지에 들어갈 내용 작성.
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = data.title
        notificationContent.subtitle = "\(data.startDate) ~ \(data.endDate)"
        notificationContent.body = "\(data.option) 알림"
        notificationContent.badge = 1
        notificationContent.sound = .default
        
        return notificationContent
    }
    
    //알림설정 옵션에 맞게 trigger를 설정.
    //dateString : 이벤트의 시작날짜로 기준이 되는 날짜.
    //forDayorTime : 이벤트 알림설정 옵션. 하루종일 모드와 시간설정 모드에 따라 컴포넌트 설정이 변경.
    func createNotificationTrigger(data: AddScheduleData) -> UNCalendarNotificationTrigger {
        
        var components = DateComponents()
        
        switch data.mode {
            
        case .date:
            components = dateComponentsForDayAgo(startDate: data.startDate, setOption: data.option)
            
        case .time:
            components = dateComponentsForTimeAgo(startDate: data.startDate, setOption: data.option)
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        return trigger
    }
    
    //하루종일 모드일 때, 알림 설정의 옵션에 맞게 DateComponent를 만들어줌.
    func dateComponentsForDayAgo(startDate: String, setOption: String) -> DateComponents {
        let calendar = Calendar.current
        let date = startDate.convertStringToDate(format: "yyyy년 MM월 dd일") //시작날짜를 Date로 변환해줌.
        
        var targetDate : Date? //옵션에 맞게 변경할 Date
        
        switch setOption {
        case "당일":
            targetDate = date //당일은 그대로.
            
        case "1일 전":
            targetDate = calendar.date(byAdding: .day, value: -1, to: date) //시작날짜에서 -1일
            
        case "3일 전":
            targetDate = calendar.date(byAdding: .day, value: -3, to: date) //시작날짜에서 -3일
            
        case "1주일 전":
            targetDate = calendar.date(byAdding: .day, value: -7, to: date) //시작날짜에서 -7일
            
        default: //설정날짜
            targetDate = setOption.convertStringToDate(format: "yyyy년 MM월 dd일") //유저가 직접 설정한 날짜를 Date로 변환.
        }
        
        let component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate ?? Date())
        print("\(component)")
        
        return component
    }
    
    //시간설정 모드일 때, 알림 설정의 옵션에 맞게 DateComponent를 만들어줌.
    func dateComponentsForTimeAgo(startDate: String, setOption: String) -> DateComponents {
        let calendar = Calendar.current
        let date = startDate.convertStringToDate(format: "yyyy년 MM월 dd일 HH시 mm분")
        
        var targetDate : Date?
        
        switch setOption {
        case "시작":
            targetDate = date
            
        case "10분 전":
            targetDate = calendar.date(byAdding: .minute, value: -10, to: date)
            
        case "30분 전":
            targetDate = calendar.date(byAdding: .minute, value: -30, to: date)
            
        case "1시간 전":
            targetDate = calendar.date(byAdding: .minute, value: -60, to: date)
            
        default: //설정날짜
            targetDate = setOption.convertStringToDate(format: "yyyy년 MM월 dd일 HH시 mm분")
        }
        
        let component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate ?? Date())
        
        print("\(component)")
        
        return component
    }
    
    func removeNotificationRequest(with identifiers: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifiers])
    }
    
    //유저가 데이터를 수정할 때, 기존에 설정해두었던 알림요청이 있다면 삭제함. 새롭게 설정한 알림요청을 받기 위해.
    func removeNotificationRequestIfNeeded(at option: String, with identifier: String) {
        print(option)
        if option != "알림 없음" {
            center.removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }
}
