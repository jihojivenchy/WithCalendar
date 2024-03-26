//
//  NotificationViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import UserNotifications

final class NotificationViewController: UIViewController {
    //MARK: - Properties
    let center = UNUserNotificationCenter.current()
    
    final let notificationView = NotificationView() //View
    
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //앱 환경설정에 갔다가 foreground로 돌아설 때 시점을 캐치해서 버튼 타이틀 변경.
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubViews()
        setupNavigationBar()
        checkNotificationAccessState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //뷰가 사라질 때 캐치 메서드를 삭제해줘야 메모리 릭을 방지할 수 있음.
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: - ViewMethod
    private func setupSubViews() {
        view.backgroundColor = .customWhiteAndBlackColor
        
        view.addSubview(notificationView)
        notificationView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        notificationView.goToNotiCenterButton.addTarget(self, action: #selector(goToCenterButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "알림 설정"
        navigationController?.navigationBar.tintColor = .blackAndWhiteColor
        
    }
    
    
    //현재 유저의 알림설정에 관한 상태를 체크하고 button 타이틀을 변경해줌.
    private func checkNotificationAccessState() {
        center.getNotificationSettings { (settings) in
           
            if settings.authorizationStatus == .authorized {
                
                DispatchQueue.main.async {
                    self.notificationView.goToNotiCenterButton.setTitle("알림 ON", for: .normal)
                }
                
            }else{
                DispatchQueue.main.async {
                    self.notificationView.goToNotiCenterButton.setTitle("알림 OFF", for: .normal)
                }
            }
        }
    }
    
    //버튼을 통해 앱 환경설정에 갔다가 다시 앱으로 돌아올 때 실행할 메서드.
    @objc func applicationWillEnterForeground() {
        checkNotificationAccessState()
    }
    
    
    //MARK: - ButtonMethod
    //앱 환경설정으로 이동.
    @objc private func goToCenterButtonPressed(_ sender : UIBarButtonItem) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    
}

