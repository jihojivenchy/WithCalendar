//
//  AppDelegate.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2022/11/02.
//

import UIKit
import Firebase
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let filePath = Bundle.main.path(forResource: "GoogleService-Info (2)", ofType: "plist")!
           let options = FirebaseOptions(contentsOfFile: filePath)
           FirebaseApp.configure(options: options!)
        
        
        requestNotificationAuthorization() //노티피케이션 요청
        UIApplication.shared.applicationIconBadgeNumber = 0
        setDefaultsFontSize() //기본텍스트크기값 설정.
        setDefaultsFont() //기본텍스트폰트 설정.
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //세로모드 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
        
    }


}

extension AppDelegate : UNUserNotificationCenterDelegate {
    //delegate와는 상관없고, 유저가 앱을 시작할 때 알림을 받을 것인지 허가요청.
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self //delegate 설정.
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        center.requestAuthorization(options: options) { granted, error in
            if let e = error {
                print("허가 요청 실패 : \(e.localizedDescription)")
            }else{
                print("허가 받음 : \(granted)")
            }
        }
    }
    
    func showRequestList() {
        let center = UNUserNotificationCenter.current()
        
        //알림 요청 리스트를 보기 위함.
        center.getPendingNotificationRequests { requests in
            for i in requests {
                print("Notification Request \(i.identifier)")
            }
        }
    }
    
    func removeDeliveredNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications() //이미 전달된 알림 요청 삭제.
        center.removeAllPendingNotificationRequests() //모든 알림 요청 삭제.
    }
    
    
    //앱이 포그라운드 상태일 때도 알림 메세지를 받을 수 있도록.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
}

//MARK: App이 처음시작될 때 초기값을 설정해주는 작업.
extension AppDelegate {
    private func setDefaultsFontSize(){
        if UserDefaults.standard.object(forKey: "fontSize") == nil {
            var fontValue : Float
            let deviceHeight = UIScreen.main.bounds.size.height
            
            if deviceHeight > 850 {
                fontValue = 12.7
                
            } else if deviceHeight > 750 {
                fontValue = 11.5
                
            } else {
                fontValue = 11
            }
            
            UserDefaults.standard.set(fontValue, forKey: "fontSize")
        }
    }
    
    private func setDefaultsFont(){
        if UserDefaults.standard.object(forKey: "fontName") == nil {
            UserDefaults.standard.set("Pretendard-SemiBold", forKey: "fontName")
        }
    }
}
