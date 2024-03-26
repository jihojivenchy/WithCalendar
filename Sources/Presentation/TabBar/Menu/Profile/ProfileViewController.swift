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
    private let profileService = ProfileService()
    private var user = User(uid: "", name: "", code: "", email: "")
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        fetchProfile()
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
    /// 프로필 조회
    private func fetchProfile() {
        loadingView.startLoading()
        
        Task {
            do {
                let user = try await profileService.fetchProfile()
                self.user = user
                profileView.configure(user: user)
                
            } catch {
                showErrorAlert(error)
            }
            
            loadingView.stopLoading()
        }
    }
    
    private func showErrorAlert(_ error: Error) {
        let popAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        guard let networkError = error as? NetworkError else {
            showAlert(title: "오류", message: error.localizedDescription, actions: [popAction])
            return
        }
        
        switch networkError {
        case .authenticationRequired:
            showAlert(title: "로그인", message: "로그인이 필요한 서비스입니다.", actions: [popAction])
            
        case .unknown(let description):
            showAlert(title: "오류", message: description, actions: [popAction])
        }
    }
}

// MARK: - 프로필 수정
extension ProfileViewController {
    @objc private func saveButtonPressed(_ sender : UIBarButtonItem) {
        view.endEditing(true)
        
        guard let name = profileView.nameTextField.text, !name.isEmpty else {
            showAlert(title: "이름을 작성해주세요.")
            return
        }
        
        user.name = name
        updateProfile()
    }
    
    private func updateProfile() {
        loadingView.startLoading()
        
        Task {
            do {
                try await profileService.updateProfile(user)
                showAlert(title: "저장이 완료되었습니다.")
                
            } catch {
                showAlert(title: "오류", message: error.localizedDescription)
            }
            
            loadingView.stopLoading()
        }
    }
}

extension ProfileViewController {
    @objc private func changeCodeButtonTapped(_ sender : UIButton) {
        let code = "abcdefghijklmnopqrstuvwxyz0123456789"  // 유저의 고유 코드를 뽑기 위한 소스.
        user.code = code.randomString(length: 5)           // 랜덤 코드 저장
        profileView.configure(user: user)
    }
}
