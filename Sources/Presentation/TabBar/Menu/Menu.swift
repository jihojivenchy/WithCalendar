//
//  Menu.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/21/24.
//

import Foundation

enum Menu: String {
    case profile = "프로필 설정"
    case displayMode = "화면 설정"
    case notification = "알림 설정"
    case notificationList = "알림 리스트"
    case font = "폰트 설정"
    case feedback = "피드백"
    case signIn = "로그인"
    case signOut = "로그아웃"
    
    /// 메뉴에 표시할 시스템 이미지 이름
    var imageName: String {
        switch self {
        case .profile: return "person"
        case .displayMode: return "display"
        case .notification: return "bell"
        case .notificationList: return "list.bullet.rectangle.portrait"
        case .font: return "pencil"
        case .feedback: return "bubble.right"
        case .signIn: return "rectangle.portrait.and.arrow.right"
        case .signOut: return "rectangle.portrait.and.arrow.right"
        }
    }
    
    /// 로그인 되었을 때, 메뉴 리스트
    static var signedInMenuItems: [Menu] {
        return [
            .profile, .displayMode, .notification, .notificationList, .font, .signOut
        ]
    }
    
    /// 로그아웃 상태일 때, 메뉴 리스트
    static var signedOutMenuItems: [Menu] {
        return [
            .profile, .displayMode, .notification, .notificationList, .font, .signIn
        ]
    }
}

struct MenuItem {
    let title: String
    let imageName: String
}
