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
    
    //MARK: - CellClickedMethod
    private func myProfileCellCliked() {
        guard isUserLoggedIn() else {
            showAlert(title: "로그인", message: "로그인이 필요한 서비스입니다.")
            return
        }
        
        let vc = MyProfileViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func displaymodeCellCliked() {
        let vc = DisplayModeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func notificationCellCliked() {
        let vc = NotificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func notiManagerCellCliked() {
//        let vc = NotificationManagerViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fontSizeAdjustCellCliked() {
        let vc = FontSizeAdjustmentViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func feedBackCellCliked() {
//        guard menuDataModel.isUserLoggedIn() else {
//            showAlert(title: "로그인", message: "로그인이 필요한 서비스입니다.")
//            return
//        }
//        
//        let vc = FeedBackViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func logInOrOutCellCliked() {
        loginAlert()
    }
}

// MARK: - Data Source
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(MenuCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        
        let menuItems = isLoggedIn ? Menu.signedInMenuItems : Menu.signedOutMenuItems
        
        cell.configure(menuItem: MenuItem(
            title: menuItems[indexPath.row].rawValue,
            imageName: menuItems[indexPath.row].imageName
        ))
        
        return cell
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)  // cell을 클릭했을 때 애니메이션 구현
        triggerHapticFeedback()  // 유저에게 리액션을 주기 위한 미세한 진동음.
        
        
        
//        if indexPath.section == 0, indexPath.row == 0{ //프로필 설정
//            myProfileCellCliked()
//
//        }else if indexPath.section == 0, indexPath.row == 1 { //화면 설정
//            displaymodeCellCliked()
//
//        }else if indexPath.section == 1, indexPath.row == 0 { //알림 설정
//            notificationCellCliked()
//
//        }else if indexPath.section == 1, indexPath.row == 1 { //알림 리스트.
//            notiManagerCellCliked()
//
//        }else if indexPath.section == 1, indexPath.row == 2{ //폰트 설정.
//            fontSizeAdjustCellCliked()
//
//        }else if indexPath.section == 2, indexPath.row == 0 { //피드백
//            feedBackCellCliked()
//
//        }else{ //로그아웃
//            logInOrOutCellCliked()
//        }
//
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
