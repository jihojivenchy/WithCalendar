//
//  TabBarPageType.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/7/24.
//

import UIKit

enum TabBarPageType: Int, CaseIterable {
    case main = 0, memo, menu
}

extension TabBarPageType {
    var tabBarItem: UITabBarItem {
        switch self {
        case .main:
            return UITabBarItem(
                title: "홈",
                image: UIImage(systemName: "house")?.resize(to: CGSize(width: 24, height: 24)),
                selectedImage: UIImage(systemName: "house.fill")?.resize(to: CGSize(width: 24, height: 24))
            )
            
        case .memo:
            return UITabBarItem(
                title: "단순 메모",
                image: UIImage(systemName: "doc.text")?.resize(to: CGSize(width: 24, height: 24)),
                selectedImage: UIImage(systemName: "doc.text.fill")?
                    .resize(to: CGSize(width: 24, height: 24))
            )
            
        case .menu:
            return UITabBarItem(
                title: "메뉴",
                image: UIImage(systemName: "menucard")?.resize(to: CGSize(width: 24, height: 24)),
                selectedImage: UIImage(systemName: "menucard.fill")?.resize(to: CGSize(width: 24, height: 24))
            )
        }
    }
}
