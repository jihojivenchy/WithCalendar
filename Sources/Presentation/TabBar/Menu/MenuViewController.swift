//
//  MenuViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 2023/04/18.
//

import UIKit
import SnapKit
import FirebaseAuth

final class MenuViewController: BaseViewController {
    // MARK: - UI
    private lazy var menuTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(MenuCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 73
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Properties
    /// 유저 로그인 상태 체크
    private var isLoggedIn = false
    final var menuDataModel = MenuDataModel()
    final let menuDataService = MenuDataService()
    
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLoginStatus()
   
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        view.backgroundColor = .customWhiteAndBlackColor
        configureNavigationBarAppearance()
        navigationItem.title = "메뉴"
    }
    
    // MARK: - Layouts
    override func configureLayouts() {
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.left.bottom.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    /// 유저의 로그인 상태 체크 및 테이블 뷰 업데이트
    private func checkLoginStatus() {
        isLoggedIn = Auth.auth().currentUser != nil
        menuTableView.reloadData()
    }
    
    /// 로그인 여부에 따라 메뉴 리스트 조회
    private func getCurrentMenuItems() -> [Menu] {
        return isLoggedIn ? Menu.signedInMenuItems : Menu.signedOutMenuItems
    }
}

// MARK: - Data Source
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCurrentMenuItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(MenuCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        
        let menuItems = getCurrentMenuItems()
        
        cell.configure(menuItem: MenuItem(
            title: menuItems[indexPath.row].rawValue,
            imageName: menuItems[indexPath.row].imageName
        ))
        
        return cell
    }
}

// MARK: - Delegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        triggerHapticFeedback()  // 유저에게 리액션을 주기 위한 미세한 진동음.
        
        let menuItems = getCurrentMenuItems()
        let selectedItem = menuItems[indexPath.row]

        switch selectedItem {
        case .profile:
            goToProfile()           // 프로필 이동
            
        case .displayMode:
            goToSetDisplayMode()    // 디스플레이 모드
            
        case .notification:
            goToSetNotification()   // 알림 설정
            
        case .notificationList:
            goToNotificationList()  // 알림 리스트
            
        case .font:
            goToSetFont()           // 폰트 설정
            
        case .feedback:
            goToFeedBack()          // 피드백
            
        case .signIn:
            signIn()                // 로그인
            
        case .signOut:
            signOut()               // 로그아웃
        }
    }
}

// MARK: - Menu 아이템 클릭
extension MenuViewController {
    private func goToProfile() {
        let vc = MyProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToSetDisplayMode() {
        let vc = DisplayModeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToSetNotification() {
        let vc = NotificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToNotificationList() {
//        let vc = NotificationManagerViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToSetFont() {
        let vc = FontSizeAdjustmentViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToFeedBack() {
        let vc = FeedBackViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signIn() {
        
    }
    
    private func signOut() {
        
    }
    
    private func logInOrOutCellCliked() {
        loginAlert()
    }
}


//MARK: - 로그인과 로그아웃에 관한 작업.
extension MenuViewController {
    //유저가 로그인했다면 로그아웃을 한 후 뷰를 이동.
    //유저가 로그인하지 않았다면 그냥 뷰로 이동.
    private func loginAlert() {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.handleAuthentication()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        if menuDataModel.isUserLoggedIn() {
            showAlert(title: "로그아웃", message: "로그아웃 하시겠습니까?", actions: [action, cancelAction])
            
        }else{
            showAlert(title: "로그인", message: "로그인 하시겠습니까?", actions: [action, cancelAction])
        }
    }
    
    private func handleAuthentication() {
        if menuDataModel.isUserLoggedIn() {
            
            menuDataService.firebaseLogout { [weak self] result in
                switch result {
                case .success(_):
                    self?.initDataPath() //로그아웃에 성공했을 경우 캘린더 데이터 경로를 초기화시켜줌.
                    
                case .failure(let err):
                    self?.showAlert(title: "로그아웃 실패", message: err.localizedDescription)
                }
            }
        }
        
        let vc = LoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
