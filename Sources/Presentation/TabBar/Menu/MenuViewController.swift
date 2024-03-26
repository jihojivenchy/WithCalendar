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
        tableView.register(WCTableTitleHeaderView.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 73
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Properties
    /// 유저 로그인 상태 체크
    private var menu = Menu()
    private let authService = AuthService()
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMenuForLoginState()
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
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    /// 유저의 로그인 상태에 따라 메뉴 업데이트
    private func updateMenuForLoginState() {
        menu.updateMenu()
        menuTableView.reloadData()
    }
}

// MARK: - Data Source
extension MenuViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        menu.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(MenuCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        
        let menuItem = menu.sections[indexPath.section].items[indexPath.row]
        cell.configure(menuItem: menuItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 1, 2:
            guard let headerView = tableView.dequeueReusableHeaderView(WCTableTitleHeaderView.self) else {
                return UIView()
            }
            headerView.configure(titleText: menu.sections[section].title)
            return headerView
            
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2: return 40
        default: return 0
        }
    }
}

// MARK: - Delegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        triggerHapticFeedback()  // 유저에게 리액션을 주기 위한 미세한 진동음.
        
        let selectedItem = menu.sections[indexPath.section].items[indexPath.row]

        switch selectedItem.title {
        case "프로필 설정":
            goToProfile()           // 프로필 이동
            
        case "화면 설정":
            goToSetDisplayMode()    // 디스플레이 모드
            
        case "알림 설정":
            goToSetNotification()   // 알림 설정
            
        case "알림 리스트":
            goToNotificationList()  // 알림 리스트
            
        case "폰트 설정":
            goToSetFont()           // 폰트 설정
            
        case "피드백":
            goToFeedBack()          // 피드백
            
        case "로그인":
            signIn()                // 로그인
            
        case "로그아웃":
            showSignOutAlert()      // 로그아웃
            
        default:
            print("Error")
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
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showSignOutAlert() {
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self else { return }
            self.signOut()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: "로그아웃", message: "로그아웃 하시겠습니까?", actions: [action, cancelAction])
    }
}


// MARK: - 로그아웃
extension MenuViewController {
    private func signOut() {
        authService.signOut { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(_):
                self.updateMenuForLoginState()
                
            case .failure(let error):
                self.showAlert(title: "로그아웃 실패", message: error.localizedDescription)
            }
        }
    }
}
