//
//  Menu.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/21/24.
//

import Foundation
import FirebaseAuth

struct Menu {
    // MARK: - Properties
    var isLoggedIn: Bool = false
    var sections: [MenuSection] = [
        MenuSection(title: "", items: [
            MenuItem(title: "프로필 설정", imageName: "person")
        ]),
        MenuSection(title: "기능", items: [
            MenuItem(title: "화면 설정", imageName: "display"),
            MenuItem(title: "알림 설정", imageName: "bell"),
            MenuItem(title: "알림 리스트", imageName: "list.bullet.rectangle.portrait"),
            MenuItem(title: "폰트 설정", imageName: "pencil")
        ]),
        MenuSection(title: "기타", items: [
            MenuItem(title: "피드백", imageName: "bubble.right"),
            MenuItem(title: "로그인", imageName: "iphone.and.arrow.forward")
        ])
    ]
    
    // MARK: - Init
    init() {
        updateMenu()
    }
    
    // MARK: - Methods
    /// 로그인 상태에 따라 메뉴 아이템이 달라짐
    mutating func updateMenu() {
        isLoggedIn = Auth.auth().currentUser != nil
        
        if isLoggedIn {
            sections[2].items[1] = MenuItem(title: "로그아웃", imageName: "rectangle.portrait.and.arrow.right")
        } else {
            sections[2].items[1] = MenuItem(title: "로그인", imageName: "iphone.and.arrow.forward")
        }
    }
}

struct MenuItem {
    let title: String
    let imageName: String
}

struct MenuSection {
    let title: String
    var items: [MenuItem]
}
