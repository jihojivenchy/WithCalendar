//
//  MenuDataModel.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import Foundation
import FirebaseAuth

struct MenuItem {
    let title: String
    let imageName: String
}

struct MenuSection {
    let title: String
    var items: [MenuItem]
}

struct MenuDataModel {
    var sections: [MenuSection] = [
            MenuSection(title: "", items: [
                MenuItem(title: "프로필 설정", imageName: "person"),
                MenuItem(title: "화면 설정", imageName: "display")
            ]),
            
            MenuSection(title: "기능", items: [
                MenuItem(title: "알림 설정", imageName: "bell"),
                MenuItem(title: "알림 리스트", imageName: "list.bullet.rectangle.portrait"),
                MenuItem(title: "폰트 설정", imageName: "pencil")
            ]),
            
            MenuSection(title: "기타", items: [
                MenuItem(title: "피드백", imageName: "bubble.right"),
                MenuItem(title: "로그아웃", imageName: "rectangle.portrait.and.arrow.right")
            ])
        ]
    
    //유저의 로그인 상태에 따라 메뉴옵션을 변경. 로그인을 했다면 메뉴옵션은 로그아웃.
    mutating func configureMenuForStatus() {
        if isUserLoggedIn() {
            sections[2].items[1] = MenuItem(title: "로그아웃", imageName: "rectangle.portrait.and.arrow.right")
        } else {
            sections[2].items[1] = MenuItem(title: "로그인", imageName: "iphone.and.arrow.forward")
        }
    }
    
    //유저가 로그인을 한지 안한지 체크하여 bool을 리턴.
    func isUserLoggedIn() -> Bool{
        return Auth.auth().currentUser != nil
    }
}
