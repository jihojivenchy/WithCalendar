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
        
        window = UIWindow(windowScene: windowScene)  // SceneDelegate의 프로퍼티인 window에 넣어준다.
        window?.rootViewController = configureTabBarController()
        window?.makeKeyAndVisible()
        
        //유저가 저장해둔 인터페이스 모드로 적용.
        let rawValue = UserDefaults.standard.integer(forKey: "Appearance")
        window?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: rawValue) ?? .unspecified
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

extension SceneDelegate {
    private func configureTabBarController() -> UITabBarController {
        let calendarViewController = CalendarViewController()
        let memoViewController = MemoViewController()
        let menuViewController = MenuViewController()

        // 각 ViewController에 대한 UINavigationController 인스턴스 생성
        let calendarNavigationController = UINavigationController(rootViewController: calendarViewController)
        let memoNavigationController = UINavigationController(rootViewController: memoViewController)
        let menuNavigationController = UINavigationController(rootViewController: menuViewController)

        // 각 탭에 해당하는 TabBarPageType 기반으로 UITabBarItem 설정
        calendarViewController.tabBarItem = TabBarPageType.main.tabBarItem
        memoViewController.tabBarItem = TabBarPageType.memo.tabBarItem
        menuViewController.tabBarItem = TabBarPageType.menu.tabBarItem

        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([calendarNavigationController, memoNavigationController, menuNavigationController], animated: true)

        // UITabBar의 tintColor 설정
        tabBarController.tabBar.tintColor = .blackAndWhiteColor
        configureTabBarAppearance()
        
        return tabBarController
    }
    
    private func configureTabBarAppearance() {
//        let tabBarItemAppearance = UITabBarItemAppearance()
//        tabBarItemAppearance.normal.iconColor = .blackAndWhiteColor
//        tabBarItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.blackAndWhiteColor ?? UIColor()]
//        tabBarItemAppearance.selected.iconColor = .signatureColor
//        tabBarItemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.blackAndWhiteColor ?? UIColor()]
//        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .clear
        tabBarAppearance.shadowImage = nil
        tabBarAppearance.shadowColor = nil
        
//        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
