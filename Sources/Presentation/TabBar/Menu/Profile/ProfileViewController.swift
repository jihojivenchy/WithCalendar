//
//  ProfileViewController.swift
//  ScheduleCalendarProject
//
//  Created by 엄지호 on 3/27/24.
//

import UIKit
import SnapKit

final class ProfileViewController: BaseViewController {
    // MARK: - UI
    private lazy var saveButton : UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self, 
            action: #selector(saveButtonPressed(_:))
        )
        return button
    }()
    
    private let profileView = ProfileView()
    private let loadingView = WCLoadingView()
    
    // MARK: - Properties
    private var user = User(uid: "", name: "", code: "", email: "")
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Configuration
    override func configureAttributes() {
        view.backgroundColor = .customWhiteAndBlackColor
        navigationItem.title = "프로필 설정"
        navigationItem.rightBarButtonItem = saveButton
        
        profileView.changeCodeButton.addTarget(self, action: #selector(changeCodeButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - Layouts
    override func configureLayouts() {
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - 프로필 조회
extension ProfileViewController {
    
}

// MARK: - 프로필 수정
extension ProfileViewController {
    @objc private func saveButtonPressed(_ sender : UIBarButtonItem) {
       
    }
}

extension ProfileViewController {
    @objc private func changeCodeButtonTapped(_ sender : UIButton) {
        let code = "abcdefghijklmnopqrstuvwxyz0123456789"  // 유저의 고유 랜덤코드를 뽑기 위한 소스.
        user.code = code.randomString(length: 5)           // 랜덤 코드 저장
        profileView.configure(user: user)
    }
}
