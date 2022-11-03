//
//  SceneDelegate.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene) //SceneDelegate의 프로퍼티인 window에 넣어준다.
        
        let calendarNavigationController = UINavigationController(rootViewController: CalendarViewController())
        let memoNavigationController = UINavigationController(rootViewController: SimpleMemoViewController())
        let menuNavigationController = UINavigationController(rootViewController: MenuViewController())
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([calendarNavigationController, memoNavigationController, menuNavigationController], animated: true)
        
        if let items = tabBarController.tabBar.items {
            items[0].selectedImage = UIImage(systemName: "calendar.badge.plus")
            items[0].image = UIImage(systemName: "calendar")
            items[0].title = "달력 메모"
            
            items[1].selectedImage = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
            items[1].image = UIImage(systemName: "square.and.pencil")
            items[1].title = "단순 메모"
            
            items[2].selectedImage = UIImage(systemName: "menucard.fill")
            items[2].image = UIImage(systemName: "menucard")
            items[2].title = "메뉴"
        }
        
        tabBarController.tabBar.barTintColor = .black
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

